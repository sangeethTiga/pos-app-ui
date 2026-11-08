import 'package:bcrypt/bcrypt.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';
import 'package:pos_app_ui/features/staff/presentation/login_cubit.dart';

var _seq = 0;
SyncChange _server(String entity, String id, Map<String, dynamic> fields) {
  _seq++;
  return SyncChange(
    changeId: 'c$_seq',
    origin: 'SERVER',
    seq: _seq,
    txId: 't$_seq',
    hlc: '1762585120000-${_seq.toString().padLeft(4, '0')}-SERVER',
    entity: entity,
    entityId: id,
    op: 'INSERT',
    fields: fields,
    createdAt: '2026-11-08T07:00:00.000Z',
  );
}

TerminalContextHolder _ctx(String type) => TerminalContextHolder()
  ..ctx = TerminalContext(
    deviceId: 'd1',
    deviceCode: 'P1',
    tokenLetter: 'A',
    storeId: 's1',
    storeName: 'Khyber Darbar',
    currency: 'AED',
    currencyDecimals: 2,
    timezone: 'Asia/Dubai',
    businessDayCutoff: '04:00',
    pricesIncludeTax: true,
    deviceType: type,
  );

void main() {
  late LocalStore store;
  late StaffSession session;
  final hash = BCrypt.hashpw('Secret-123', BCrypt.gensalt(logRounds: 4)).replaceFirst(r'$2a$', r'$2y$');

  setUp(() async {
    store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open('P1');
    session = StaffSession();
    await store.applyIncoming([
      _server('user', 'u1', {
        'name': 'Asha',
        'username': 'asha',
        'email': 'anucashier@gmail.com',
        'password_hash': hash,
        'active': true,
        'permissions': ['shift.open_close', 'order.create', 'payment.take'],
        'roles': ['Cashier'],
      }),
      _server('user', 'u2', {
        'name': 'Ravi',
        'email': 'ravicaptain@gmail.com',
        'password_hash': hash,
        'active': true,
        'permissions': ['order.create'],
        'roles': ['Captain'],
      }),
      _server('user', 'u3', {
        'name': 'Gone',
        'password_hash': hash,
        'active': false,
        'roles': ['Cashier'],
      }),
      _server('user', 'u4', {
        'name': 'Boss',
        'email': 'manager@gmail.com',
        'password_hash': hash,
        'active': true,
        'permissions': ['payment.take', 'shift.open_close'],
        'roles': ['Manager'],
      }),
      _server('user', 'u5', {
        'name': 'Sana',
        'email': 'sancashier@gmail.com',
        'password_hash': hash,
        'active': true,
        'permissions': ['order.create', 'payment.take'],
        'roles': ['Cashier'],
      }),
    ]);
  });
  tearDown(() => store.db.close());

  LoginCubit cubit(String type) {
    final ctx = _ctx(type);
    return LoginCubit(StaffRepository(store, MemorySecureStore()), session, ShiftService(store, ctx), store, ctx);
  }

  test('cashier device lists only Cashier accounts, captain device only Captain accounts', () async {
    final cashier = cubit('CASHIER');
    await cashier.load();
    expect(cashier.state.users.map((u) => u.loginName), ['anucashier@gmail.com', 'sancashier@gmail.com']);
    expect(cashier.state.otherStaff, 2); // manager + captain
    final captain = cubit('CAPTAIN');
    await captain.load();
    expect(captain.state.users.map((u) => u.loginName), ['ravicaptain@gmail.com']);
  });

  test('loads users and default shift names', () async {
    final c = cubit('CASHIER');
    await c.load();
    expect(c.state.users.map((u) => u.id), ['u1', 'u5']);
    expect(c.state.users.first.loginName, 'anucashier@gmail.com');
    expect(c.state.shiftNames, LoginCubit.defaultShiftNames);
    expect(c.state.shiftName, 'Morning Shift');
    expect(c.state.needsShift, isTrue);
  });

  test('shift names come from the store setting', () async {
    await store.applyIncoming([
      _server('store_setting', 'st1', {
        'key': 'shift_names',
        'value': {
          'v': ['Breakfast', 'Dinner'],
        },
      }),
    ]);
    final c = cubit('CASHIER');
    await c.load();
    expect(c.state.shiftNames, ['Breakfast', 'Dinner']);
    expect(c.state.shiftName, 'Breakfast');
  });

  test('wrong password is refused, right one opens the named shift with the drawer balance', () async {
    final c = cubit('CASHIER');
    await c.load();
    c.selectUser(c.state.users.first);
    c.selectShift('Evening Shift');

    await c.login(password: 'nope', openingBalance: '0');
    expect(c.state.error, 'Wrong password');
    expect(c.state.loggedIn, isFalse);

    await c.login(password: 'Secret-123', openingBalance: '150.50');
    expect(c.state.loggedIn, isTrue);
    expect(session.value?.id, 'u1');
    final shift = (await store.all('shift')).single;
    expect(shift.data['name'], 'Evening Shift');
    expect(shift.data['opening_float_minor'], 15050);

    // Next login: shift already open, no shift / drawer fields.
    final next = cubit('CASHIER');
    await next.load();
    expect(next.state.shiftAlreadyOpen, isTrue);
    expect(next.state.openShiftName, 'Evening Shift');
    expect(next.state.needsShift, isFalse);
  });

  test('cashier without shift permission cannot open the shift', () async {
    final c = cubit('CASHIER');
    await c.load();
    c.selectUser(c.state.users.last); // Sana: no shift.open_close
    await c.login(password: 'Secret-123', openingBalance: '0');
    expect(c.state.loggedIn, isFalse);
    expect(c.state.error, contains('may not open a shift'));
    expect(await store.all('shift'), isEmpty);
  });

  test('captain device logs in without shift or drawer balance', () async {
    final c = cubit('CAPTAIN');
    await c.load();
    expect(c.state.needsShift, isFalse);
    c.selectUser(c.state.users.last);
    await c.login(password: 'Secret-123', openingBalance: '');
    expect(c.state.loggedIn, isTrue);
    expect(await store.all('shift'), isEmpty);
  });

  test('missing user or password gives a message, not a check', () async {
    final c = cubit('CASHIER');
    await c.load();
    await c.login(password: 'x', openingBalance: '0');
    expect(c.state.error, 'Select your user name');
    c.selectUser(c.state.users.first);
    await c.login(password: '', openingBalance: '0');
    expect(c.state.error, 'Enter your password');
    await c.login(password: 'Secret-123', openingBalance: 'abc');
    expect(c.state.error, 'Invalid open drawer balance');
  });
}
