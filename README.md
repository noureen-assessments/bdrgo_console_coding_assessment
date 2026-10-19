# badrgo Ops Console

A Flutter web dashboard for the badrgo city operations team, built on the badrgo
sandbox API (REST, GraphQL, Server-Sent Events and WebSocket).

> Status: **M1 (authentication)** is done, with the offline part of M7
> (offline banner, automatic retry). M2–M7 follow, each in its own folder under
> `lib/features/`.

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

**Web auth mode.** `--dart-define=WEB_AUTH_MODE=storage` (default) or `cookie`;
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
│   ├── session/                  # SessionExpiryNotifier: every transport reports 401 here
│   ├── storage/                  # TokenStorage interface, StorageKeys
│   └── utils/                    # safeCall, AppLogger, AppSecureStorage
└── shared/                       # reused across features
    ├── use_cases/use_case.dart   # UseCase<T, Params> → Either<Failure, T>
    ├── pages/                    # not found
    └── widgets/                  # NoDataFoundWidget, MessageBanner
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

### Styling and responsive layout

Widgets never write raw colors, sizes, text styles or icons:

| File | Holds |
| --- | --- |
| `config/theme/app_colors.dart` | Every color |
| `config/theme/app_text_styles.dart` | Typography (`headline`, `headlineCompact`, `title`, `body`, `caption`) and the Material `textTheme` |
| `config/theme/app_dimensions.dart` | Spacing scale, radii, icon and control sizes, content widths, breakpoints |
| `config/theme/app_styles.dart` | Decorations and component styles (notices, primary button, animation duration) |
| `config/theme/app_theme.dart` | `ThemeData` assembled from the four files above |
| `core/constants/app_assets.dart` | Every icon (and later image) |

**One layout for phone and web, no layout package.** `core/utils/responsive.dart`
adds `context.isMobile` / `context.isDesktop` / `context.pagePadding`, built on
`MediaQuery.sizeOf`, so a widget rebuilds when the browser window is resized.
Below 600 px the app uses tighter padding and smaller titles, the sign-out
button shows only its icon, and the user's name, role and city move under the
app-bar title. Forms and empty states are capped at `formMaxWidth` and
centered on wide windows.

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
stacking every parent segment.

**Auth guard.** `onGenerateRoute` asks `isSignedIn()` (a callback, so the router
does not know about `AuthBloc`). Signed out, every URL shows `/sign-in`;
signed in, `/sign-in` shows the console. Permission guards (M2) go in the same
place.

### Authentication (M1)

```
features/auth/
├── data/          AuthRemoteDataSource (REST), MeModel / CityModel / PermissionsModel, AuthRepositoryImpl
├── domain/        CurrentUser, City, Permissions, AuthRepository, 4 use cases
└── presentation/  AuthBloc (app-wide), SignInBloc (sign-in page), AuthGate, widgets
```

- **Sign-in** posts to `/api/auth/sign-in/email`, stores `token`, then loads
  `GET /api/me`. The sign-in page shows the server's own `message` (wrong
  password, banned user). Better Auth answers `{ code, message }` without the
  `error` envelope, and `ApiErrorParser` reads both shapes.
- **Refresh.** `AuthGate` keeps the navigator out of the tree until
  `AuthBloc` has checked the stored session with `GET /api/me`. The first route
  (say a refreshed `/trips/42`) is then built with the real session, so there
  is no flash of sign-in. If the check fails because the user is offline, in
  maintenance or the server errors, the token is kept and a Retry screen
  shows. The check runs again by itself when the browser is back online.
- **Sign-out** calls `/api/auth/sign-out` (revokes the token, checked with
  curl: the old token then gets `401`). If the server cannot be reached the
  user stays signed in and sees why, because forgetting the token locally
  would leave it valid on the server.
- **Any 401, any transport.** Everything reports to one
  `SessionExpiryNotifier` (in `core/session`). REST and GraphQL HTTP `401`s
  report through `AuthInterceptor`, and only for requests that carried a
  token, so a wrong password never counts. GraphQL `200` responses with
  `extensions.code: UNAUTHENTICATED` report through `DioGraphQLConsumer`. The
  SSE and WebSocket clients (M3/M5) will call `notify()` on their own `401` /
  refused handshake.
- **No loop.** The repository forgets the token as soon as a `401` is
  reported, and `AuthBloc` only reacts while it is `AuthAuthenticated`. Later
  `401`s from requests still in flight hit a signed-out state and are ignored,
  and the server is never called again to sign out (that would only `401`
  again).
- **Closing realtime connections.** On sign-out or expiry, `AppRouter.showSignIn`
  clears the whole page stack. Realtime Blocs are page-scoped
  (`BlocProvider` under signed-in pages), so their `close()` runs and tears
  down SSE and WebSocket subscriptions. Nothing survives into the next
  account.
- **States are `sealed`** (`AuthRestoring`, `AuthRestoreFailed`,
  `AuthAuthenticated`, `AuthUnauthenticated`), so the gate and widgets switch
  on them exhaustively.
- **Blocs only call use cases** (`RestoreSession`, `SignIn`, `SignOut`,
  `WatchSessionExpiry`). No feature Bloc depends on another feature:
  connectivity reaches `AuthBloc` as a plain `AuthConnectionRestored` event
  sent by `ConnectionRestoredListener` in the view.

### Connectivity (part of M7)

`features/connectivity`: `ConnectivityRepository` (wraps `connectivity_plus`,
which follows the browser's `online`/`offline` events), `WatchConnectivityUseCase`,
and an app-wide
`ConnectivityBloc` with `sealed` `ConnectivityOnline` / `ConnectivityOffline`
states.

- `OfflineBanner` sits above every page (in `MaterialApp.builder`).
- A failed session check retries by itself when the connection comes back
  (`ConnectionRestoredListener` in `AuthGate` sends `AuthConnectionRestored`).
  Sign-in is not retried: the user submits again.
- Maintenance (`503`, health polling with backoff) is the rest of M7 and is
  built with the realtime features it has to reconnect.

### Token storage

Based on
[Securely storing JWTs in Flutter web apps](https://dev.to/carminezacc/securely-storing-jwts-in-flutter-web-apps-2nal).
Everything depends on the `TokenStorage` interface, and `initCore` picks the
implementation:

| Platform | Mode | Credential | Token in the client |
| --- | --- | --- | --- |
| Web | `storage` (default) | `Authorization: Bearer` | AES-GCM via WebCrypto in sessionStorage (`AppSecureStorage`) |
| Web | `cookie` (opt-in) | Server's `HttpOnly` cookie, sent with `withCredentials` | Memory only (`InMemoryTokenStorage`), never in browser storage |
| Android | n/a | `Authorization: Bearer` | AES-GCM, key in the Android Keystore (`AppSecureStorage`) |
| iOS | n/a | `Authorization: Bearer` | Keychain, `first_unlock_this_device` (`AppSecureStorage`) |

Select the web mode with `--dart-define=WEB_AUTH_MODE=cookie|storage`. An
unknown value stops the app at startup.

**Why storage mode is the default (decided in M1).** The sandbox sets
`__Secure-better-auth.session_token` with **`SameSite=Lax`**. An app on
`localhost` is a different site from `sandbox.badrgo.com`, so the browser never
sends that cookie on the app's XHR calls. Cookie mode would lose the session
on every refresh, and the brief requires the session to survive one. SSE and
WebSocket need `?token=` anyway. Storage mode keeps the token encrypted in
sessionStorage, so it survives a refresh but not closing the tab, and two tabs
never share a session.

**Cookie mode (opt-in, for a same-site deployment).** `flutter_secure_storage`
on web writes to browser storage, which page scripts can always read even when
encrypted. Only an `HttpOnly` cookie is out of reach of JavaScript. Cookie
mode does three things:

- Dio uses `BrowserHttpClientAdapter(withCredentials: true)`, so the browser
  stores the server's cookie and sends it on every REST and GraphQL call.
- The token from the sign-in response is held in memory for the current page
  only. That covers `?token=` on SSE and WebSocket, as the brief requires.
- After a refresh, memory is empty. The session is restored from the cookie,
  and realtime URLs are built without `?token=`. `EventSource` then needs
  `withCredentials: true`, and the WebSocket handshake sends the cookie
  itself.

**What the server must support for cookie mode** (checked against the sandbox
in M1: items 2 and 3 work, item 1 does not, because of `SameSite=Lax`):

1. Set the cookie on sign-in (`HttpOnly; Secure; SameSite=None`) and expire it
   on sign-out.
2. Answer CORS with `Access-Control-Allow-Credentials: true` and the exact
   origin. A `*` wildcard makes the browser block credentialed requests.
3. Accept the cookie on REST, GraphQL, SSE and WebSocket.
4. Optionally issue an anti-CSRF token for a request header, as the article
   recommends.

Storage mode protects the token at rest but not against XSS. In both modes XSS
prevention
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
| `connectivity_plus` | Online/offline status behind `ConnectivityRepository`. On web it listens to the browser's `online`/`offline` events, and the same code works on mobile. |
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

- **Auth endpoints use a different error shape.** `/api/auth/sign-in/email`
  answers `401 { "code": "INVALID_EMAIL_OR_PASSWORD", "message": … }`, not
  the documented `{ "error": { code, message } }` envelope. The app reads both.
- **Session cookie is `SameSite=Lax`**, so cross-site apps (the brief's
  `localhost` setup) cannot use it. The app uses the bearer token instead (see
  [Token storage](#token-storage)).
- **Demo accounts drift.** On 2026-10-20, `viewer.doha@demo.test` signed in as
  `ops_manager` in Al Rayyan and `dispatch.doha@demo.test` as `support`.
  Another candidate had probably re-roled them. The UI follows `/api/me`, so
  it adapts, but the brief's role table may not match what reviewers see.
- **GraphQL answers `200` without a token** for introspection-level queries
  (`{ __typename }`), so a missing session only shows up as
  `extensions.code: UNAUTHENTICATED` on real fields. That case is handled.
- **Build cache (tooling):** after adding a web plugin, `flutter build web`
  reused a cached plugin registrant without it, and `connectivity_plus`
  failed at runtime with `MissingPluginException`. Fix: delete
  `.dart_tool/flutter_build` (or `flutter clean`) and rebuild.
