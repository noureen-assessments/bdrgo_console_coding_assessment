# badrgo Ops Console

A Flutter web dashboard for the badrgo city operations team, built on the badrgo
sandbox API (REST, GraphQL, Server-Sent Events and WebSocket).

> Status: **M1 (authentication)** and **M2 (role-aware shell)** are done, with
> the offline part of M7 (offline banner, automatic retry). **M3 (dashboard)**
> has its live KPI tiles and the trips-over-time chart. **M4 (trips)** has its
> paginated list with filters. The rest of M4 and M5–M7 follow, each in its
> own folder under `lib/features/`.

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
| DEV | `lib/main_dev.dart` | "DEV" corner banner, Bloc event logging |
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

**Guards.** The router depends only on the `SessionAccess` interface
(`isSignedIn`, `can(permission)`), not on `AuthBloc`. Signed out, every URL
shows `/sign-in`. Signed in, `/` and `/sign-in` open the first section the
user may open, a section URL opens the shell for that section, and anything
else is not found. See [Role-aware shell](#role-aware-shell-m2).

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
  `extensions.code: UNAUTHENTICATED` report through `DioGraphQLConsumer`. A
  refused SSE connection hides its status, so the SSE client asks
  `SessionChecker` (`GET /api/me`) and the `401` reports through
  `AuthInterceptor` (see [Dashboard (M3)](#dashboard-m3)). The WebSocket
  client (M5) will report its `4001` close code.
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

### Role-aware shell (M2)

```
features/auth/
├── domain/services/session_access.dart              SessionAccess interface
└── presentation/
    ├── services/auth_bloc_session_access.dart       Adapter: SessionAccess over AuthBloc
    └── widgets/permission_gate.dart                 Guard widget for buttons and pages
features/shell/presentation/
├── navigation/nav_destination(s).dart               Registry of sections + permission
├── pages/shell_page.dart                            App bar, menu, guarded section
└── widgets/                                         WebNavigation, MobileNavigation, NoAccessView, ShellAppBar
```

Nothing branches on the role name; the role is only a label.

| Section | URL | Needs |
| --- | --- | --- |
| Dashboard | `/dashboard` | `kpi:read` |
| Trips | `/trips` | `trip:read` |
| Live map | `/live-map` | `driver:track` |
| Alerts | `/alerts` | `alert:read` |

**Patterns used, and why**

- **Registry (open/closed).** `NavDestinations.all` lists every section
  as one `NavDestination` (route, label, icon, permission). The router, both
  menus and the no-access page read from it, so a new section is one new
  entry and no other code changes.
- **Dependency inversion + adapter.** The router needs two answers: "signed
  in?" and "may they do X?". It gets them from the `SessionAccess` interface
  (auth domain). `AuthBlocSessionAccess` adapts `AuthBloc` to it and is
  registered in `initAuth()`. The router never reads the Bloc or the
  service locator, and tests pass a `FakeSessionAccess`.
- **Guard.** `PermissionGate(permission, child, fallback)` is the one place
  the UI checks a permission. It hides action buttons (M4–M6:
  `PermissionGate(permission: TripPermission.assign, child: …)`), and the
  shell wraps each section in it with `NoAccessView` as the fallback. It
  listens to `AuthBloc`, so it rebuilds when the permissions change.

**Behaviour**

- **Menu** lists `NavDestinations.allowedFor(user.permissions)`:
  `WebNavigation` (side menu, icon then label) on web, `MobileNavigation` (drawer) on phones.
  With the sandbox matrix, `support` has no Dashboard and no Live map, and
  `viewer` has no Live map.
- **Home.** `/` opens the first section the user may open, so `support`
  lands on Trips, not on an empty dashboard. A user with no section gets
  the no-access page without a "Go home" button.
- **No access.** A section URL the user may not open (a bookmark, a typed
  URL) still opens the shell, with `NoAccessView` in place of the content,
  not a crash or an empty page.
- **Switching sections** replaces the page without a transition, so the
  content swaps at once and old sections (and later their realtime
  connections) never pile up on the back stack.
- **The shell shows** the user's name, role label and city ("All cities"
  for `super_admin`) in the app bar.
- **Role changed on the server.** The docs say to re-fetch `/api/me` after
  any `403`. Every transport reports a `403` to one `AccessDeniedNotifier`
  (in `core/session`, next to `SessionExpiryNotifier`): HTTP `403`s through
  `AuthInterceptor`, and GraphQL `FORBIDDEN` on a `200` through
  `DioGraphQLConsumer`. The SSE and WebSocket clients will call `notify()`
  themselves. `AuthBloc` re-fetches the profile with a `droppable`
  transformer, so a burst of `403`s sends one request. The menu, the open
  section and every `PermissionGate` then rebuild from the new permissions.
  If the re-fetch fails (offline, maintenance) the current permissions
  stay. A banned user's `401` signs them out as in M1.
- **No ShellBloc.** The shell's only state is the signed-in user, which
  `AuthBloc` already holds. A second Bloc would just copy it.

### Dashboard (M3)

```
core/network/sse/
├── sse_client.dart                  SseClient interface, SseMessage, SseStatus
├── sse_client_impl.dart             Shared connection, JSON decoding, retry with backoff
├── sse_transport.dart               SseTransport interface (adapter over the browser)
├── event_source_transport_web.dart  Native EventSource (package:web)
└── sse_transport_io.dart            Stub for mobile and VM tests
core/network/backoff.dart            Exponential backoff, injected
core/session/session_checker.dart    SessionChecker: "is the session still valid?" over REST
core/utils/number_formatters.dart    Counts, percentages, money (intl)
core/utils/date_formatters.dart      Times, hours, days (intl)
features/dashboard/
├── data/         DashboardQueries (GraphQL documents), DashboardRemoteDataSource
│                 (GraphQL kpis + SSE kpi), KpisModel
├── domain/       Kpis, TripKpis, DriverKpis, TripSeriesPoint, KpiRange;
│                 GetKpis / WatchKpis / WatchLiveStatus / GetTripSeries
└── presentation/ DashboardBloc, TripChartBloc, KpiTileGrid, KpiTile, LiveStatus,
                  TripChartCard, TripRangeSwitch, TripLineChart
```

**KPI tiles.** The tiles are:

- active trips (with requested / assigned / in progress)
- completed trips
- cancellation rate
- revenue
- drivers available / on trip
- open alerts

They load once with the GraphQL `kpis` query (`DashboardQueries.kpis`). The
range is the domain enum `KpiRange`, passed from the Bloc down to the data
source and sent as the `$range` variable, so no range string is hard-coded
outside the enum. The tiles ask for `KpiRange.last24Hours`, the same window as
the SSE `kpi` event. There is no `cityId`, so the server scopes them to the
user's city. The SSE `kpi` event
then replaces them every 5 s. Both payloads have the same shape, so one
`KpisModel` parses both.

- **Races.** The GraphQL answer and the first SSE event can arrive in any
  order. `DashboardBloc` only shows a value that is not older than the one
  on screen (`Kpis.generatedAt`).
- **Revenue** is a list with one `Money` per currency. Each currency gets its
  own line, and amounts are never added across currencies. `intl` picks the
  number of decimals from the currency code.
- **Live status.** A chip shows "Live · Updated 14:05:09", or "Reconnecting…"
  while the SSE connection is down, so stale numbers are marked.
- **Errors.** If the first load fails but a live event arrives, the tiles show.
  Otherwise the page shows an error with Retry.

**Trips-over-time chart.** A card under the tiles with a **Last 24h / Last 7
days** switch and a line chart (`fl_chart`) of total, completed and cancelled
trips, plus a legend and a tooltip per bucket.

- **Data.** The GraphQL query `DashboardQueries.tripSeries` asks only for
  `kpis(range: $range) { series { bucket total completed cancelled } }`. It
  shares `rangeVariables` with the tiles query. The server returns hourly
  buckets for 24 h and daily buckets for 7 days.
- **Separate Bloc.** `TripChartBloc` has its own loading, error and empty
  states, so a chart failure never hides the tiles. The tiles always show
  24 h; only the chart switches.
  - One event, `TripChartRangeSelected(range)`, covers the first load, the
    switch and Retry.
  - Every state carries the selected range, so the switch always shows it.
- **Fast switching.** The event uses `restartable()`, so picking a new range
  cancels the older request. A slow 24 h answer can never replace the 7 days
  chart.
- **Time labels.** Hours show in the browser's local time. Days are read in
  UTC, because daily buckets start at 00:00 UTC and local time would shift
  them to the day before west of UTC. About six labels fit on the axis
  whatever the bucket count.
- **Not live.** The chart is loaded with GraphQL only. The brief asks for live
  tiles, and the 7 days view would not change within minutes anyway.

**SSE: why native `EventSource`.** Dio's web adapter and `package:http`'s
`BrowserClient` read an XHR response as a whole, so an SSE response that
never ends delivers nothing (the "events arrive in bulk" problem). A common
fix is a raw XHR that reads `responseText` on each `progress` event. It was
rejected because:

- `responseText` keeps growing for the whole session.
- A hand-written parser can lose events that are split across two chunks.
- It has no reconnect and no `Last-Event-ID`.
- It needs the deprecated `dart:html`.

That approach mainly exists to send an `Authorization` header, which this
API does not need (`?token=` works). `EventSource` streams each event, parses
the format, and reconnects with `Last-Event-ID` by itself, with no extra
package. If headers were ever needed, `fetch` with a `ReadableStream` would be
the next choice, behind the same `SseTransport` interface.

**SSE lifecycle.**

- **One shared connection (observer).** `SseClient.messages` is a broadcast
  stream. The first listener opens the connection and the last one closes
  it. Each feature filters the events it needs; the dashboard keeps `kpi`.
  The server sends every topic the role may read.
  - Today only the dashboard listens, so the connection lives while the
    dashboard is open.
  - Once the alerts feed (M6) listens for the whole session, the same
    connection stays open from sign-in to sign-out.
- **Clean-up.** Page Blocs cancel their subscriptions on close. Sign-out
  clears the page stack, so no connection outlives a session, and a new
  account always connects with its own token.
- **Dropped connection.** The browser reconnects by itself; the status shows
  `connecting`.
- **Refused connection.** A `401` or `503` closes `EventSource` for good, and
  the browser hides the status.
  - `SessionChecker.check()` makes one REST call, so `AuthInterceptor`
    handles a `401` exactly as for any request. The user is signed out and
    the pages close, which cancels the listeners, so there is no retry and
    no loop.
  - Otherwise (maintenance, network) the client retries with exponential
    `Backoff`: 1 s, doubling up to 30 s.
  - The SSE client depends only on the `SessionChecker` interface, not on
    REST or `/api/me`.
- **Testing (adapter).** `SseClientImpl` is pure Dart. `EventSource` sits
  behind `SseTransport`, so the reconnect logic can be unit-tested with a
  fake transport and a fake `SessionChecker`. The web adapter is picked by a
  conditional export, as with the Dio adapter.

**Section pages.** `NavDestination` is plain data: route, label, icon and
permission. The router picks each section's page (for example
`DashboardPage` for the dashboard, a placeholder until a section is built)
and passes it to `ShellPage.section(destination:, page:)`, so the shell never
imports a feature.

### Trips (M4)

```
features/trips/
├── data/         TripsQueries (GraphQL document + variables), TripsRemoteDataSource,
│                 TripSummaryModel, TripPageModel
├── domain/       TripSummary, TripStatus, TripFilter, TripPage, TripPageRequest;
│                 GetTrips
└── presentation/ TripsBloc, TripsView, TripFilterBar (search, date range, status
                  chips), TripList, TripListTile, TripStatusBadge
```

**List and paging.** The GraphQL `trips(filter, first, after)` query loads 20
trips at a time, newest first. Scrolling near the end (or **Load more** when
the rows don't fill the screen) asks for the page after `pageInfo.endCursor`.

- **Only the row's fields.** The schema nests both ways (a driver has a
  current trip, which has a driver …), but a query is as deep as you ask. A
  row needs only rider, driver and city *names*, so `TripSummary` is flat
  and the nesting never reaches the app. The detail view gets its own query.
- **No duplicate rows.** The cursor is an offset, so trips created between
  two pages push rows into the next page. `TripPage.append` skips ids that
  are already shown.

**Filters.** Status chips (none selected = every status), a date range and a
search box (exact trip id, address text or rider name).

- **Only set criteria are sent.** An empty string would filter to nothing,
  so `TripsQueries.filterVariables` leaves unset fields out.
- **Dates are whole days.** The API excludes `to` (`requestedAt < to`), so
  a range up to Oct 20 is sent as "before Oct 21".
- **Search runs on Enter**, not on every key press, so typing sends no
  requests and needs no debounce.

**Races.** A new filter uses `restartable()`, so a slow answer for an old
filter never replaces the list. The next page uses `droppable()`, so a burst of
scroll events sends one request. If the filter changes while a page is
loading, that page is dropped, because it belongs to a list that is gone.

**States.** Every state carries the filter, so the filter bar stays usable on
loading, error and empty states.

- A failed first page shows Retry.
- A failed next page keeps the loaded rows and shows Retry under them;
  scrolling does not retry by itself.
- An empty result offers **Clear filters**.

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
| `equatable` | Value equality for states, events, entities and failures without codegen. Pinned to `^2.0.7`: every `fl_chart` release (up to 1.2.0) requires `equatable ^2`, and the app only uses `Equatable` and `props`, which are the same in 2.x and 3.x. |
| `fl_chart` | The trips-over-time line chart. Pure Flutter (no JS chart library), well maintained, with tooltips and custom axis labels. |
| `fpdart` | Typed `Either<Failure, T>` results from repositories and use cases; actively maintained. |
| `dio` | Interceptors (auth header, logging), cancel tokens, typed errors; works on web through the browser XHR adapter. |
| `get_it` | Simple service locator; manual registration keeps wiring explicit. |
| `flutter_secure_storage` | Token storage for web and mobile (see [Token storage](#token-storage)). Used through `AppSecureStorage` behind the `TokenStorage` interface. |
| `connectivity_plus` | Online/offline status behind `ConnectivityRepository`. On web it listens to the browser's `online`/`offline` events, and the same code works on mobile. |
| `flutter_web_plugins` (SDK) | `usePathUrlStrategy()` for clean URLs (`/trips/…` instead of `/#/trips/…`). |
| `web` | Typed browser APIs (`EventSource`) for SSE, from the Dart team; replaces the deprecated `dart:html`. See [Dashboard (M3)](#dashboard-m3). |
| `intl` | Number, currency and time formats (thousands separators, decimals per currency code). |
| `bloc_concurrency` | `droppable()` for the `403` re-fetch, so a burst of `403`s sends one `/api/me`. |
| `bloc_test`, `mocktail` (dev) | Bloc and mock testing without codegen. |

**GraphQL without a GraphQL package.** The console only sends queries with
variables. `DioGraphQLConsumer` (POST to the GraphQL endpoint, parse `data`/`errors`)
reuses the same Dio and auth interceptor, and avoids a second HTTP stack and a
normalised cache that would fight live SSE updates.

Packages like `graphql_flutter` mostly add a normalized cache, fetch policies,
mutations and subscriptions. This brief sends every write over REST and all
live data over SSE/WebSocket, so none of those would be used. These GraphQL
practices are followed:

- Each query asks only for the fields its screen shows.
- Documents are constants in `data/queries/` (e.g. `DashboardQueries.kpis`),
  never built in widgets or by string interpolation.
- Dynamic values go in `variables` (`$range: KpiRange!`).
- Responses are parsed into typed models at the data layer.
- A repository hides GraphQL from the Bloc.
- Errors are mapped from `extensions.code` to typed `Failure`s.

### Planned for the milestones

Added when the feature that needs them is built, so nothing unused ships:

- **WebSocket:** `web_socket_channel`, a stream API that is easy to wrap with
  reconnect/backoff and to fake in tests.
- **Map:** `flutter_map` + `latlong2` with OpenStreetMap tiles.

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
- **SSE hides the HTTP status.** A refused `EventSource` (for example
  `401 UNAUTHENTICATED` on `/api/events`) only fires `error`, so the app
  calls `GET /api/me` to learn why. An `event: error` frame before closing
  would let browser clients react directly.
- **Build cache (tooling):** after adding a web plugin, `flutter build web`
  reused a cached plugin registrant without it, and `connectivity_plus`
  failed at runtime with `MissingPluginException`. Fix: delete
  `.dart_tool/flutter_build` (or `flutter clean`) and rebuild.
