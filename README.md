# badrgo Ops Console

A Flutter web dashboard for the badrgo city operations team. It runs on the
badrgo sandbox API and uses REST, GraphQL, Server-Sent Events (SSE) and
WebSocket, each for its own job.

## Running

Requires Flutter stable 3.38+ (Dart 3.10+).

```bash
flutter pub get
```

```bash
flutter run -d chrome -t lib/main_dev.dart --dart-define=API_URL=<API_BASE_URL>
```

- **`API_URL` is required.** No URL is written in the code; the app stops at
  startup if it is missing, so a build never points at the wrong server.
- **Flavors.** Each flavor has its own entry point:

  | Flavor | Entry point | Differences |
  | --- | --- | --- |
  | DEV | `lib/main_dev.dart` | "DEV" corner banner, Bloc event logging |
  | ALPHA | `lib/main_alpha.dart` | "ALPHA" corner banner, Bloc logging in debug |
  | PROD | `lib/main_prod.dart` | No banner, no Bloc logging |

- **Tests:** `flutter test`
- **Release build:**

  ```bash
  flutter build web --release -t lib/main_prod.dart --dart-define=API_URL=<API_BASE_URL>
  ```

No secrets live in the repo. Demo credentials are typed in at runtime.

## Architecture

Clean MVVM with BLoC, organised by feature. Dependencies point inward only:
**View → Bloc → Domain ← Data**.

```
Widget → Bloc (event) → UseCase → Repository → DataSource → REST / GraphQL / SSE
       ← state        ←         ← Either<Failure, T>
```

| Layer | Holds | Rule |
| --- | --- | --- |
| View (`pages`, `widgets`) | Screens and widgets | Renders state, sends events; no logic, no API calls |
| Bloc (`bloc`) | UI state | Event-driven `Bloc`, calls use cases only |
| Domain (`domain`) | Entities, repository interfaces, use cases | Pure Dart |
| Data (`data`) | Data sources, models, repository implementations | Transport and JSON live here only |

```
lib/
├── main_common.dart        app start: URL strategy, Bloc observer, DI, runApp
├── main_dev / main_alpha / main_prod.dart
├── my_app.dart
├── config/                 env, flavors, routing, theme
├── core/                   shared infrastructure (network, errors, session, storage, utils)
├── shared/                 widgets, pages and the UseCase base used by every feature
└── features/
    ├── auth/               sign-in, session, permissions
    ├── shell/              app bar, menu, sections
    ├── dashboard/          KPI tiles and trips chart
    ├── trips/              list, filters, live rows, actions, detail
    ├── live_map/           driver map over WebSocket, driver panel
    └── connectivity/       online / offline
```

Every feature has the same folders (`data`, `domain`, `presentation`) and an
`init<Feature>()` that registers its classes in the service locator.

## Modules

### Core

| Added | Why |
| --- | --- |
| `ApiConsumer` / `DioConsumer` (REST) and `GraphQLConsumer` | One place for HTTP; both share one Dio with the auth header and logging |
| `SseClient` over the browser's `EventSource` | One shared live connection that every feature listens to |
| `WebSocketService` (`web_socket_channel`) | One shared WebSocket; a feature listens to a topic with `watch(topic)` and the service subscribes, reconnects and subscribes again |
| Sealed `Failure` types and `ApiErrorParser` | REST `error.code` and GraphQL `extensions.code` become the same typed failures (`Unauthenticated`, `Forbidden`, `NotFound`, `InvalidState`, `Validation`, `Maintenance`, `Network`, `Server`); both `409` codes, `INVALID_STATE` and `CONFLICT`, become `InvalidState` |
| `safeCall` | Repositories return `Either<Failure, T>` instead of throwing |
| `SessionExpiryNotifier` / `AccessDeniedNotifier` | Every transport reports a `401` or `403` to one place |
| `TokenStorage` (`AppSecureStorage`, `InMemoryTokenStorage`) | The token is stored encrypted; the rest of the app depends only on the interface |
| `Backoff` | Retry delays (1 s doubling to 30 s) for reconnecting |
| `NumberFormatters`, `DateFormatters` (`intl`) | Counts, money per currency code, percentages, times |
| Theme files and `AppAssets`, `AppStrings` | Colors, text styles, sizes, icons and text each live in one file; widgets never hard-code them |
| `context.isMobile` / `context.pagePadding` | One responsive layout for phone and web, no layout package |

### Authentication (M1)

| Added | Why |
| --- | --- |
| Sign-in page (`SignInBloc`) | Signs in over REST and shows the server's own error message (wrong password, banned user) |
| `AuthBloc` and `AuthGate` | Restores the session with `GET /api/me` before any page is built, so a refresh keeps the user signed in |
| Sign-out over REST | The token is revoked on the server when it can be reached, and always forgotten on this device, even offline |
| One `401` path | Any `401` from any transport signs the user out once and closes the pages, which also closes their live connections |

### Role-aware shell (M2)

| Added | Why |
| --- | --- |
| `Permission` / `Permissions` from `/api/me` | Menus, routes and buttons follow permissions, never role names |
| `NavDestinations` (registry) | Every section is one entry (route, label, icon, permission); a new section is one new entry |
| `SessionAccess` interface + `AuthBlocSessionAccess` adapter | The router asks "signed in?" and "may they?" without knowing the Bloc |
| `PermissionGate` | The single UI permission check, used for sections and action buttons |
| `ShellPage`, `WebNavigation`, `MobileNavigation` | Side menu on web, drawer on phones, with the user's name, role and city |
| `NoAccessView` | A section the user may not open shows a clear "no access" state |
| Re-fetch `/api/me` after a `403` | A role changed on the server is picked up and the UI adapts |

| Section | Needs |
| --- | --- |
| Dashboard | `kpi:read` |
| Trips | `trip:read` |
| Live map | `driver:track` |
| Alerts | `alert:read` |

### Dashboard (M3)

| Added | Why |
| --- | --- |
| KPI tiles (`DashboardBloc`) | Active trips, completed, cancellation rate, revenue, drivers available / on trip, open alerts. Loaded with GraphQL `kpis`, then kept live by the SSE `kpi` event |
| Newest value wins (`generatedAt`) | The GraphQL answer and the first SSE event can arrive in any order |
| Revenue per currency | `revenue` is a list; each currency is shown on its own line |
| Live status chip | Shows "Live · Updated …" or "Reconnecting…" |
| Trips-over-time chart (`TripChartBloc`, `fl_chart`) | Last 24h / Last 7 days switch; its own loading, error and empty states |

### Trips (M4)

**List and filters**

| Added | Why |
| --- | --- |
| GraphQL `trips(filter, first, after)` | 20 trips per page, newest first; the next page loads on scroll or **Load more** |
| `TripSummary` with only the row's fields | Each query asks only for what its screen shows; the `TripRow` fragment is shared by every trip query |
| Status chips, date range, search | Filters for the list; only the filters that are set are sent. With no status picked, cancelled trips are left out |
| `restartable()` / `droppable()` | A new filter cancels the old request; scrolling sends one next-page request at a time |

**Live rows**

| Added | Why |
| --- | --- |
| SSE `trip.created` / `trip.updated` | The list updates without a reload |
| One GraphQL `trip(id)` per change | The event says which trip changed; the row is then built the same way as a loaded row |
| Stale answers dropped by status order | A trip's status only moves forward, so an older answer never replaces a newer row |
| Green / amber row tint | New and changed rows are marked until the next reload |

**Actions: assign, cancel, refund**

| Added | Why |
| --- | --- |
| `TripAction` commands (`AssignDriver`, `CancelTrip`, `RefundTrip`) | Command pattern: one use case and one Bloc send any action over REST |
| `TripActionRules` | One table of which trip statuses show each action (assign: requested; cancel: requested, assigned; refund: completed) |
| `PermissionGate` on each button | A button shows only when the user has the permission and the status allows it |
| `TripActionDialog` | Shared dialog frame: fields, server error, Close / Submit, spinner |
| Assign dialog | Picks from the available drivers in the trip's city (GraphQL) |
| Cancel dialog | Reason, 3–200 characters |
| Refund dialog | Amount above 0 and not more than what is left to refund, and a reason |
| `409 INVALID_STATE` handling | The dialog closes, the server's message is shown, and the trip reloads to its real status |

**Detail**

| Added | Why |
| --- | --- |
| Trip detail page | Opened by tapping a row; the trip id is passed as a navigation argument |
| `TripDetail` (extends `TripSummary`) | Adds rider and driver contact, vehicle, distance, refunds, cancellation and the status timeline; the action buttons work on it unchanged |
| Sections: rider, driver, route, fare, cancellation, status timeline | Everything about one trip on one screen; phones and emails come masked from the server for roles without `pii:read` |
| `TripDetailBloc` | Loading, loaded, "Trip not found" (another city or a wrong id) and error with Retry |
| Live detail | The page reloads when its trip changes over SSE |
| Actions in the detail | The same assign, cancel and refund buttons as the list |

### Live map (M5)

| Added | Why |
| --- | --- |
| WebSocket `drivers.locations` | A full snapshot about every 2 s replaces all markers; no deltas to merge |
| `watch(topic)` drives the connection | The first listener connects and subscribes, the last one disconnects, so leaving the page or signing out closes the socket |
| Reconnect with `Backoff` (1 s doubling to 30 s) | Subscriptions belong to the connection, so every new connection subscribes again |
| Session check before each retry, stop on close code `4001` | A banned or signed-out user is signed out instead of retrying forever |
| `flutter_map` with OpenStreetMap tiles | Markers coloured by status (available, on trip), a legend and the OSM credit |
| "Live" / "Reconnecting…" status | The last markers stay on the map while it reconnects |
| Driver panel (GraphQL `driver(id)`) | Details, vehicle and current trip in one query; loading, not found and error with Retry |
| Open trip | Opens the trip detail page, shown only with `trip:read` |
| Panel beside the map on web, at the bottom on phones | The map keeps its zoom and position while the panel opens and closes |

### Alerts (M6)

**Feed**

| Added | Why |
| --- | --- |
| REST `GET /api/alerts` | 20 alerts per page, newest first; the next page loads on scroll or **Load more** |
| SSE `alert.created` / `alert.acknowledged` | Both events carry the full alert: a new one goes on top, a known one replaces its row |
| Older events ignored | An alert never goes back from acknowledged to open, so a replayed event cannot undo it |
| Repeated rows skipped | New alerts on top move the server's pages, so the next page can repeat rows already shown |
| Acknowledged rows greyed | Open alerts stand out; acknowledged ones also say "Acknowledged" |
| Severity badge | Info, warning and critical, each with its own color |
| Loading, error with Retry, empty, "Live" / "Reconnecting" | Every state of the page is shown |

**Acknowledge**

| Added | Why |
| --- | --- |
| REST `POST /api/alerts/{id}/acknowledge` | The answer is the updated alert, so the row greys at once without a reload |
| `PermissionGate` on the button | Shown only with `alert:acknowledge` and only on open alerts |
| One small Bloc per button | Each row sends its own request; a double tap sends once |
| `409` and other errors | The server's message is shown in a red snackbar; the row is fixed by the SSE event |

**Critical alerts**

| Added | Why |
| --- | --- |
| Red banner above every page | A new critical alert is seen wherever the user is, until it is dismissed or acknowledged |
| Banner at the app root, not in the shell | Switching sections or opening a trip detail keeps the banner |
| **View** opens a dialog | One alert, or a list of them, each with its details and an Acknowledge button |
| Acknowledged by anyone | The alert leaves the banner and the dialog; the dialog closes after the last one |
| Created only while signed in with `alert:read` | Signing out or losing the permission closes it, so the next user starts empty |

### Maintenance and connectivity (M7)

**Maintenance**

| Added | Why |
| --- | --- |
| One Dio interceptor for every `503` | REST, GraphQL and the `/api/me` check that SSE and the WebSocket run after a refused connection all pass through it, so any of them starts maintenance |
| Maintenance screen over the page | Shows the reason, the server's message and since when (for example "Since 14:05 · 12 min"); the page stays underneath, so the user lands back where they were |
| Poll `GET /api/health` with `Backoff` | The first wait is the server's `retryAfterSeconds`, then 1 s doubling to 30 s; a network error while the API restarts counts as still down |
| Recovers by itself when health returns `200` | The screen goes away and SSE and the WebSocket reconnect at once instead of waiting out their backoff |
| User stays signed in | A `503` never signs out; if the session could not be restored during maintenance, it is restored again when the API is back |
| Stale data refreshed | Dashboard KPIs and chart, the alerts feed, the trips list (with its filters) and the open trip detail reload; the live map needs nothing, its snapshot comes every 2 s |
| Dropped realtime while the API is up | Only the light "Reconnecting" chip on the page, not the maintenance screen |

**Offline**

| Added | Why |
| --- | --- |
| `ConnectivityBloc` (`connectivity_plus`) | Knows when the browser goes offline or back online |
| `OfflineBanner` | Shown above every page while offline |
| Automatic retry | A failed session check runs again when the connection returns |

## Key decisions

- **SSE with the browser's `EventSource`** (`package:web`). Dio and
  `package:http` read a web response only when it ends, so a stream that
  never ends delivers nothing. `EventSource` streams each event and reconnects
  by itself. It sits behind an `SseTransport` interface, so the client logic
  can be tested with a fake.
- **WebSocket with `web_socket_channel`.** The API is a plain WebSocket with
  JSON messages (`{ type, payload }`), not Socket.IO. The connection is passed
  into `WebSocketServiceImpl`, so the reconnect logic can be tested with a
  fake connection.
- **One shared SSE connection.** The first listener opens it and the last one
  closes it; each feature keeps only the events it needs.
- **GraphQL without a GraphQL package.** Queries are constants with
  variables, sent through the same Dio as REST. Writes go over REST and live
  data over SSE, so a GraphQL cache would not be used.
- **Token in encrypted session storage** by default (`WEB_AUTH_MODE=storage`).
  The session survives a refresh but not closing the tab. A cookie mode is
  available with `--dart-define=WEB_AUTH_MODE=cookie` for a same-site
  deployment.
- **`Navigator` with named routes**, no router package. Signed out, every URL
  shows sign-in; signed in, `/` opens the first section the user may open.
- **`get_it` with manual registration.** `sl` is read only in the
  composition root, the router and `BlocProvider`s; everything else gets its
  dependencies through its constructor.

**Design patterns used:** Registry (`NavDestinations`), Adapter
(`AuthBlocSessionAccess`, `SseTransport`), Guard (`PermissionGate`), Observer
(shared SSE stream, `MaintenanceNotifier`), Command (`TripAction`), Repository
and Dependency Inversion throughout.

## Packages

| Package | Why |
| --- | --- |
| `flutter_bloc`, `bloc` | State management (required) |
| `bloc_concurrency` | `restartable()` and `droppable()` for requests and live streams |
| `equatable` | Value equality without code generation |
| `fpdart` | `Either<Failure, T>` results |
| `dio` | REST and GraphQL over HTTP, with interceptors |
| `get_it` | Dependency injection |
| `flutter_secure_storage` | Encrypted token storage |
| `connectivity_plus` | Online / offline status |
| `web` | Browser `EventSource` for SSE |
| `intl` | Number, currency and date formats |
| `fl_chart` | The trips-over-time chart |
| `web_socket_channel` | The WebSocket for the live map |
| `flutter_map`, `latlong2` | The live map with OpenStreetMap tiles |
| `flutter_web_plugins` (SDK) | Clean URLs without `#` |
| `bloc_test`, `mocktail` (dev) | Bloc and mock testing |

## Sandbox rules followed

- No fixed ids are relied on.
- With `super_admin`, demo accounts are never edited, banned or deleted.
