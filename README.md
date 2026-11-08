# POS terminal app (Flutter)

Terminal app for the multi-terminal POS SaaS backend (`new-pos-backend`). Targets Windows and Android.
Backend contract: `new-pos-backend/FLUTTER_BACKEND_INTEGRATION.md` and `docs/openapi.yaml`.

## Architecture

Feature-first folders, Clean Architecture inside each feature, BLoC for state.

```
lib/
  main.dart                 bootstrap: DI, then runApp
  app/                      App widget, go_router routes, theme
  core/
    config/                 AppConfig (--dart-define API_BASE_URL)
    di/injection.dart       get_it registrations (core, then one block per feature)
    error/failure.dart      freezed sealed Failure (network / server / unauthorized / unexpected)
    network/                Dio client, HMAC RequestSigner, DeviceAuthInterceptor, error-envelope mapping
    storage/                SecureStore port (flutter_secure_storage; in-memory fake for tests)
    utils/result.dart       Result<T> = Success | Err (repositories never throw)
  features/
    <feature>/
      data/                 models (freezed + json_serializable), remote/local data sources, repository impl
      domain/               entities (freezed), repository interfaces, use cases
      presentation/         bloc or cubit (freezed events/states), pages, widgets
```

Rules:
- Dependencies point inwards: presentation -> domain <- data. Domain has no Flutter, Dio or JSON imports.
- Data sources throw; repositories catch and return `Result<T>` with a `Failure`.
- Blocs/cubits are `registerFactory` (one per screen); services and repositories are lazy singletons.
- JSON is snake_case on the wire: set once in `build.yaml` (`field_rename: snake`), so models use camelCase fields.
- Device credentials live only in secure storage, never in SQLite or logs.
- Every device request is signed by `DeviceAuthInterceptor` (bearer + `X-Timestamp`/`X-Nonce`/`X-Signature`);
  pass `Options(extra: {'public': true})` for the unsigned ones (registration, token refresh).

## Features

| Feature | State | What it does | Status |
|---|---|---|---|
| `device_setup` | `DeviceSetupBloc` | Pairing (`POST /devices/register`), credentials in secure storage, token refresh | done, e2e |
| `sync` | `SyncEngine`, `SyncScheduler`, `RealtimeClient` | Gateway claim/heartbeat, push (ACK only by `accepted`), pull, CONTINUOUS / MANUAL run / SCHEDULED occurrence + catch-up, Reverb notifications | done, e2e |
| `staff` | `PinLoginCubit` | Cashier PIN login offline (Argon2id/bcrypt from the server, cached per terminal), lockout after 5 wrong PINs | done |
| `shift` | `ShiftService` | Business day, open shift with float, cash in / paid out, blind close (expected vs counted), day close | done, e2e |
| `sales` | `SellCubit`, `CheckoutService`, `PricingEngine` | Catalogue grid, cart, takeaway/dine-in, discount, split payment, cash rounding; one atomic local transaction per sale (order, lines, payments, stock, balanced ledger, KOT) | done, e2e |
| `printing` | `PrinterService`, `TicketFormatter` | ESC/POS receipt + KOT to LAN printers (TCP 9100), cash drawer kick | done (network printers only) |
| `home` | `HomeCubit` | Device status (signed `GET /devices/me`) | done |
| LAN sync | — | Terminal-to-terminal replication and gateway election | **not built** |

Core pieces: `core/database` (Drift: `records` replica, `change_log`, `key_values`), `core/sync`
(`LocalStore` with the backend's merge rules, `Hlc`), `core/security/pin_hash.dart`,
`core/terminal/terminal_context.dart` (store time zone, business date, money format).

Flow: splash -> pairing (once) -> PIN login -> open shift -> sell -> pay -> receipt/KOT -> auto upload.

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after changing any freezed/json model
dart run build_runner watch --delete-conflicting-outputs   # while developing
flutter analyze
flutter test                                               # unit + bloc + widget tests (e2e skipped)
flutter run -d windows --dart-define=API_BASE_URL=http://localhost:8000/api/v1
flutter run -d android --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1   # emulator -> host
```

Generated `*.g.dart` / `*.freezed.dart` files are committed so the app builds right after a clone.

### End-to-end tests against a real backend

Backend: `php artisan db:seed --class=DemoSeeder`, then a fresh code per test with
`php artisan pos:registration-code DXB-01` (DXB-01 must be in CONTINUOUS mode for the sale test).

```bash
export E2E_BASE_URL=http://localhost:8000/api/v1
E2E_STORE_CODE=DXB-01 E2E_REG_CODE=<code> flutter test test/e2e/pairing_e2e_test.dart
E2E_STORE_CODE=DXB-01 E2E_REG_CODE=<code> E2E_PIN=1234 flutter test test/e2e/sale_e2e_test.dart
E2E_STORE_CODE=DXB-02 E2E_REG_CODE=<code> E2E_OWNER_EMAIL=owner@alnoor.test E2E_OWNER_PASSWORD=password \
  flutter test test/e2e/scheduled_mode_e2e_test.dart
```
The sale test pairs, downloads the catalogue and users, checks a real PIN, opens a shift, sells with
card + cash, closes shift and day, and asserts the backend applied every transaction.

## Adding a feature

1. `lib/features/<name>/{data,domain,presentation}` as above.
2. Models: `@freezed abstract class X with _$X` + `fromJson`; run build_runner.
3. Repository interface in `domain/`, implementation in `data/` returning `Result<T>`.
4. Bloc with `@freezed sealed` events and states.
5. Register in `core/di/injection.dart`, add the route in `app/router.dart`, add tests under `test/features/<name>/`.
