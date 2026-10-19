# badrgo Ops Console

A Flutter web dashboard for the badrgo city operations team, built on the badrgo
sandbox API (REST, GraphQL, Server-Sent Events and WebSocket).

> Status: **project setup and architecture**. Feature milestones (M1–M7) are not
> implemented yet; each gets its own folder under `lib/features/` when built.

## Running

Requires Flutter stable 3.38+ (Dart 3.10+).

```bash
flutter pub get
```

There are three flavors (`Flavor.DEV`, `Flavor.ALPHA`, `Flavor.PROD`), each with
its own entry point. Each one builds a `FlavorConfig` and passes it to
`mainCommon` in `main_common.dart`:

| Flavor | Entry point | Differences |
| --- | --- | --- |
| DEV | `lib/main_dev.dart` (also `lib/main.dart`) | "DEV" corner banner, Bloc event logging |
| ALPHA | `lib/main_alpha.dart` | "ALPHA" corner banner, Bloc event logging in debug |
| PROD | `lib/main_prod.dart` | No banner, no Bloc logging |

```bash
flutter run -d chrome -t lib/main_dev.dart --dart-define=API_URL=<API_BASE_URL>
```

```bash
flutter run -d chrome -t lib/main_alpha.dart --profile --dart-define=API_URL=<API_BASE_URL>
```

```bash
flutter run -d chrome -t lib/main_prod.dart --release --dart-define=API_URL=<API_BASE_URL>
```

`lib/main.dart` also starts DEV, so `flutter run -d chrome --dart-define=API_URL=…`
works without `-t`.

**Web auth mode.** `--dart-define=WEB_AUTH_MODE=cookie` (default) or `storage`;
see [Token storage](#token-storage).

**API URL (required).** No URL is hard-coded anywhere in the code. It comes
only from `--dart-define=API_URL=…`, which `FlavorValues.fromApiUrl` splits into
`baseProtocol` (`https`) and `baseHost` (host, keeping any port
or path prefix). If `API_URL` is missing, the app stops at startup with
`API_URL is not set. Run with --dart-define=API_URL=https://…`, so a build can
never silently point at the wrong server. Web has no native flavors, so `--flavor` is not used: the entry point
picks the flavor. VS Code users can use the `badrgo console (DEV)` / `(ALPHA)` /
`(PROD)` launch configs, which read `API_URL` from your shell environment
(`export API_URL=…`). Every transport URL is derived from this base URL in
`ApiUrls`.

No secrets live in the repo. Demo credentials are entered at runtime only.

```bash
flutter test
```

On macOS, `flutter test` builds native assets for `objective_c` (pulled in by
`flutter_secure_storage` → `path_provider`), which needs the Xcode license to
be accepted once (`sudo xcodebuild -license accept`). Web builds are not
affected.

```bash
flutter build web --release -t lib/main_prod.dart --dart-define=API_URL=<API_BASE_URL>
```

## Architecture

Clean MVVM with BLoC, organised by feature. Dependencies point inward only:
**View → ViewModel → Domain ← Data**.

**Data flow:** `Widget → Bloc (event) → UseCase → Repository → DataSource → ApiConsumer / GraphQLConsumer → Either<Failure, T> → emit State`

```
lib/
├── main_common.dart              # shared bootstrap: URL strategy, BlocObserver, DI, runApp
├── main_dev.dart / main_alpha.dart / main_prod.dart  # flavor entry points
├── main.dart                     # default entry, runs dev
├── my_app.dart                   # MaterialApp.router
├── config/
│   ├── env/env.dart              # API_URL (required) and WEB_AUTH_MODE from --dart-define
│   ├── flavor/flavor_config.dart # Flavor (DEV/ALPHA/PROD), FlavorValues, FlavorConfig
│   ├── routing/                  # AppRouter (Navigator, onGenerateRoute) + RouteNames
│   └── theme/                    # AppTheme, AppColors
├── core/                         # feature-agnostic infrastructure
│   ├── bloc/                     # AppBlocObserver
│   ├── constants/                # every string literal, grouped by where it belongs:
│   │   ├── app_strings.dart      #   user-facing text
│   │   ├── api_endpoints.dart    #   REST paths
│   │   ├── graphql_endpoints.dart #  GraphQL path + request/response keys
│   │   ├── sse_events.dart       #   SSE path + event names
│   │   ├── websocket_events.dart #   WebSocket path + channels
│   │   ├── api_error_constants.dart # error envelope keys, codes, HTTP statuses
│   │   ├── api_headers.dart      #   header names
│   │   ├── url_constants.dart    #   schemes, separators, token query param
│   │   └── log_constants.dart    #   log tags, messages, redaction patterns
│   ├── di/injection_container.dart   # sl + initCore()
│   ├── errors/                   # sealed Failure hierarchy, ApiErrorParser
│   ├── network/                  # ApiUrls, ApiConsumer/DioConsumer, GraphQLConsumer, interceptors
│   ├── storage/                  # TokenStorage interface, StorageKeys
│   └── utils/                    # safeCall, AppLogger, AppSecureStorage
└── shared/                       # reused across features
    ├── use_cases/use_case.dart   # UseCase<T, Params> → Either<Failure, T>
    ├── pages/                    # not found, setup placeholder
    └── widgets/                  # NoDataFoundWidget (empty / not found / no access)
```

Features live in `lib/features/<feature>/` and are added with the milestone
that needs them: `auth` (M1), `shell` (M2), `dashboard` (M3), `trips` (M4),
`live_map` (M5), `alerts` (M6) and `connectivity` (M7). Each feature has the
same layers, plus a `<feature>_injection.dart` with an `init<Feature>()` that
`initCore()` calls:

```
features/<feature>/
├── data/
│   ├── datasources/     # remote (REST / GraphQL / SSE / WS) data sources
│   ├── models/          # DTOs + mapping to entities
│   └── repositories/    # repository implementations, wrapped in safeCall
├── domain/
│   ├── entities/        # pure Dart
│   ├── repositories/    # interfaces
│   └── usecases/
├── presentation/
│   ├── bloc/            # Bloc + events + states (ViewModel)
│   ├── pages/
│   └── widgets/
└── <feature>_injection.dart
```

| Layer | Responsibility |
| --- | --- |
| View (`pages`, `widgets`) | Render state, dispatch events. No logic, no API calls. ≤ 150 lines per file. |
| ViewModel (`bloc`) | Event-driven `Bloc` (not Cubit) with UI state and permission checks. Calls use cases. |
| Domain | Entities, repository interfaces, use cases. No Flutter, Dio or JSON. |
| Data | Repository implementations, transport calls, DTO ↔ entity mapping. |

### Error handling

- `DioConsumer` and `DioGraphQLConsumer` throw a `Failure`. REST `error.code`
  and GraphQL `extensions.code` map to the same types, with the HTTP status as
  fallback: `UnauthenticatedFailure`, `ForbiddenFailure`, `NotFoundFailure`,
  `InvalidStateFailure`, `ValidationFailure` (with `details`),
  `MaintenanceFailure` (`reason`, `retryAfter`, `since`), `NetworkFailure`,
  `CancelledFailure` and `ServerFailure`.
- Repositories wrap calls in `safeCall`, which returns `Either<Failure, T>`.
  It only catches `Failure`, `DioException` and `FormatException`, so real bugs
  are not hidden.
- `Failure` is `sealed`, so Blocs handle it with an exhaustive `switch`.

### Routing

`Navigator` with named routes, no router package. `AppRouter.onGenerateRoute`
maps a route name to a page, and unknown names get `NotFoundPage`. On web the
route name is the browser URL (path strategy, no `#`), so refresh and deep
links work. `onGenerateInitialRoutes` opens only the requested page instead of
stacking every parent segment. Auth and permission guards will go in
`onGenerateRoute`. A `navigatorKey` lets the session layer send the user to
sign-in on a 401.

### Token storage

Based on
[Securely storing JWTs in Flutter web apps](https://dev.to/carminezacc/securely-storing-jwts-in-flutter-web-apps-2nal).
Everything depends on the `TokenStorage` interface, and `initCore` picks the
implementation:

| Platform | Mode | Credential | Token in the client |
| --- | --- | --- | --- |
| Web | `cookie` (default) | Server's `HttpOnly; Secure; SameSite=None` cookie, sent with `withCredentials` | Memory only (`InMemoryTokenStorage`), never in browser storage |
| Web | `storage` (fallback) | `Authorization: Bearer` | AES-GCM via WebCrypto in sessionStorage (`AppSecureStorage`) |
| Android | n/a | `Authorization: Bearer` | AES-GCM, key in the Android Keystore (`AppSecureStorage`) |
| iOS | n/a | `Authorization: Bearer` | Keychain, `first_unlock_this_device` (`AppSecureStorage`) |

Select the web mode with `--dart-define=WEB_AUTH_MODE=cookie|storage`. An
unknown value stops the app at startup.

**Why cookie mode is the default on web.** `flutter_secure_storage` on web
writes to browser storage, and page scripts can always read browser storage,
even when the value is encrypted (the key is stored next to it). Only an
`HttpOnly` cookie is out of reach of JavaScript. Cookie mode does three
things:

- Dio uses `BrowserHttpClientAdapter(withCredentials: true)`, so the browser
  stores the server's cookie and sends it on every REST and GraphQL call.
- The token from the sign-in response is held in memory for the current page
  only. That covers `?token=` on SSE and WebSocket, as the brief requires.
- After a refresh, memory is empty. The session is restored from the cookie,
  and realtime URLs are built without `?token=`. `EventSource` then needs
  `withCredentials: true`, and the WebSocket handshake sends the cookie
  itself.

**What the server must support for cookie mode** (to confirm with the API
documentation in M1, not assumed here):

1. Set the cookie on sign-in (`HttpOnly; Secure; SameSite=None`) and expire it
   on sign-out.
2. Answer CORS with `Access-Control-Allow-Credentials: true` and the exact
   origin. A `*` wildcard makes the browser block credentialed requests.
3. Accept the cookie on REST, GraphQL, SSE and WebSocket.
4. Optionally issue an anti-CSRF token for a request header, as the article
   recommends.

If the sandbox does not support this, build with `WEB_AUTH_MODE=storage`.
That keeps the session across a refresh using encrypted sessionStorage, which
protects the token at rest but not against XSS. Closing the tab ends the
session, and two tabs never share one session. In both modes XSS prevention
still matters: no HTML rendering of server strings, and no third-party
scripts.

`AppSecureStorage` decrypts the token once at startup and then caches it in
memory. Errors are logged through `AppLogger` with JWTs, long keys and emails
masked.

### Dependency injection

`get_it` with manual registration (no codegen). `sl` is only read in the
composition root (`main_common.dart`, the router, `BlocProvider`s); everything else
gets dependencies through its constructor. Blocs are registered with
`registerFactory`, repositories and data sources as lazy singletons.

## Package choices

| Package | Why |
| --- | --- |
| `flutter_bloc` / `bloc` | Required. Event-based `Bloc`s give a traceable event log and transformers for live streams. |
| `equatable` | Value equality for states, events, entities and failures without codegen. |
| `fpdart` | Typed `Either<Failure, T>` results from repositories and use cases; actively maintained. |
| `dio` | Interceptors (auth header, logging), cancel tokens, typed errors; works on web through the browser XHR adapter. |
| `get_it` | Simple service locator; manual registration keeps wiring explicit. |
| `flutter_secure_storage` | Token storage for web and mobile (see [Token storage](#token-storage)). Used through `AppSecureStorage` behind the `TokenStorage` interface. |
| `flutter_web_plugins` (SDK) | `usePathUrlStrategy()` for clean URLs (`/trips/…` instead of `/#/trips/…`). |
| `bloc_test`, `mocktail` (dev) | Bloc and mock testing without codegen. |

**GraphQL without a GraphQL package.** The console only sends queries with
variables. `DioGraphQLConsumer` (POST to the GraphQL endpoint, parse `data`/`errors`)
reuses the same Dio and auth interceptor, and avoids a second HTTP stack and a
normalised cache that would fight live SSE updates.

### Planned for the milestones

Added when the feature that needs them is built, so nothing unused ships:

- **SSE:** the browser's native `EventSource` through `package:web`. It
  reconnects on its own, sends `Last-Event-ID` on reconnect, and needs no extra
  dependency. The token goes in `?token=` because `EventSource` cannot set
  headers.
- **WebSocket:** `web_socket_channel`, a stream API that is easy to wrap with
  reconnect/backoff and to fake in tests.
- **Map:** `flutter_map` + `latlong2` with OpenStreetMap tiles.
- **Charts:** `fl_chart`.

## Sandbox rules followed

- Shared data: no fixed ids are relied on.
- With `super_admin`, only users created by this app are changed; demo accounts
  are never edited, banned or deleted.

## Known issues / API feedback

None yet.
