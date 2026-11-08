import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../terminal/terminal_cubit.dart';
import '../../terminal/widgets/sync_chip.dart';
import '../data/staff_repository.dart';
import 'login_cubit.dart';

/// Terminal login: brand on the left; user name, password, shift and opening drawer balance on the
/// right; device role badge (CASHIER / CAPTAIN) top right. Passwords are checked on the terminal.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.storeName = ''});

  /// Shown as the wordmark on the left.
  final String storeName;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _password = TextEditingController();
  final _balance = TextEditingController(text: '0.0');
  bool _showPassword = false;

  @override
  void dispose() {
    _password.dispose();
    _balance.dispose();
    super.dispose();
  }

  void _login() {
    context.read<LoginCubit>().login(password: _password.text, openingBalance: _balance.text);
  }

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: PosColors.navy,
      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
    );
    return Theme(
      data: base.copyWith(
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.white70, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (a, b) => (!a.loggedIn && b.loggedIn) || (a.error != b.error && b.error != null),
        listener: (context, state) {
          if (state.loggedIn) {
            _password.clear();
            context.go(Routes.sell);
          } else {
            _password.clear();
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();
          return Scaffold(
            body: BlocListener<TerminalCubit, TerminalState>(
              listenWhen: (a, b) => a.lastReport != b.lastReport,
              listener: (context, _) => cubit.load(),
              child: SafeArea(
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, c) {
                        final wide = c.maxWidth >= 900;
                        final form = _form(context, state, cubit);
                        return wide
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Center(child: _Wordmark(name: widget.storeName)),
                                  ),
                                  SizedBox(width: (c.maxWidth * 0.36).clamp(420, 760).toDouble(), child: form),
                                  const SizedBox(width: 24),
                                ],
                              )
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 40),
                                    _Wordmark(name: widget.storeName),
                                    const SizedBox(height: 40),
                                    form,
                                  ],
                                ),
                              );
                      },
                    ),
                    Positioned(top: 4, right: 4, child: _RoleBadge(deviceType: state.deviceType)),
                    Positioned(
                      top: 4,
                      left: 8,
                      child: Row(
                        children: [
                          const SyncChip(),
                          IconButton(
                            tooltip: 'Device status',
                            icon: const Icon(Icons.info_outline, color: Colors.white54),
                            onPressed: () => context.push(Routes.home),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _form(BuildContext context, LoginState state, LoginCubit cubit) {
    if (state.loaded && state.users.isEmpty) return const _NoUsers();
    const gap = SizedBox(height: 44);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<StaffUser>(
              key: const Key('userField'),
              initialValue: state.selected,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
              hint: const Text('User Name'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20, color: Colors.white),
              items: [
                for (final u in state.users)
                  DropdownMenuItem(value: u, key: Key('user-${u.id}'), child: Text(u.username ?? u.name)),
              ],
              onChanged: state.checking ? null : cubit.selectUser,
            ),
            gap,
            TextField(
              key: const Key('passwordField'),
              controller: _password,
              obscureText: !_showPassword,
              enabled: !state.checking,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    key: const Key('togglePassword'),
                    icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, size: 30),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                ),
              ),
              onSubmitted: (_) => _login(),
            ),
            if (state.needsShift) ...[
              gap,
              DropdownButtonFormField<String>(
                key: const Key('shiftField'),
                initialValue: state.shiftName,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                hint: const Text('Shift'),
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                items: [for (final n in state.shiftNames) DropdownMenuItem(value: n, child: Text(n))],
                onChanged: state.checking ? null : cubit.selectShift,
              ),
              gap,
              TextField(
                key: const Key('drawerField'),
                controller: _balance,
                enabled: !state.checking,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  labelText: 'Open Drawer Balance',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF111111))),
                ),
                onSubmitted: (_) => _login(),
              ),
            ] else if (state.shiftAlreadyOpen) ...[
              const SizedBox(height: 20),
              Text(
                'Shift open${state.openShiftName != null ? ': ${state.openShiftName}' : ''}',
                key: const Key('shiftOpenInfo'),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
            if (state.error != null) ...[
              const SizedBox(height: 20),
              Text(
                state.error!,
                key: const Key('loginError'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 16),
              ),
            ],
            const SizedBox(height: 56),
            Center(
              child: SizedBox(
                width: 274,
                height: 88,
                child: FilledButton(
                  key: const Key('loginButton'),
                  style: FilledButton.styleFrom(
                    backgroundColor: PosColors.navy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: state.checking ? null : _login,
                  child: state.checking
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Login', style: TextStyle(fontSize: 26, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.isEmpty ? 'POS' : name,
          style: const TextStyle(fontSize: 88, fontWeight: FontWeight.w600, color: Colors.white, height: 1),
        ),
        const SizedBox(height: 10),
        const Text(
          'POINT OF SALE',
          style: TextStyle(fontSize: 18, letterSpacing: 2, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.deviceType});

  final String deviceType;

  @override
  Widget build(BuildContext context) => Row(
    key: const Key('deviceTypeBadge'),
    children: [
      Text(
        deviceType,
        style: const TextStyle(color: PosColors.online, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      const SizedBox(width: 8),
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: PosColors.online,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    ],
  );
}

class _NoUsers extends StatelessWidget {
  const _NoUsers();

  @override
  Widget build(BuildContext context) {
    final t = context.watch<TerminalCubit>().state;
    final r = t.lastReport;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No staff on this terminal yet.', style: TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            t.syncing
                ? 'Downloading users and menu from the server...'
                : r == null
                ? 'Waiting for the first sync.'
                : 'Last sync: ${r.result.name}${r.message != null ? ' — ${r.message}' : ''}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: t.syncing ? null : () => context.read<TerminalCubit>().syncNow(),
            icon: const Icon(Icons.sync),
            label: const Text('Sync now'),
          ),
        ],
      ),
    );
  }
}
