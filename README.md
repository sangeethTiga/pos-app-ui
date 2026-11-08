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

| Feature | State | What it does |
|---|---|---|
| `device_setup` | `DeviceSetupBloc` | Splash decides paired/unpaired; pairing form calls `POST /devices/register`, stores credentials |
| `home` | `HomeCubit` | Shows the paired store/terminal; signed `GET /devices/me` proves credentials and signature |

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

### End-to-end test against a real backend

Create a store and a registration code in the backend (admin API), then:

```bash
E2E_BASE_URL=http://localhost:8000/api/v1 E2E_STORE_CODE=ST-0007 E2E_REG_CODE=<code> flutter test --tags e2e
```
It pairs a terminal for real and makes a signed `GET /devices/me`.

## Adding a feature

1. `lib/features/<name>/{data,domain,presentation}` as above.
2. Models: `@freezed abstract class X with _$X` + `fromJson`; run build_runner.
3. Repository interface in `domain/`, implementation in `data/` returning `Result<T>`.
4. Bloc with `@freezed sealed` events and states.
5. Register in `core/di/injection.dart`, add the route in `app/router.dart`, add tests under `test/features/<name>/`.
