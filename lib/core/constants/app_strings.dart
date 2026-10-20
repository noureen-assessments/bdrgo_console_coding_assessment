abstract final class AppStrings {
  static const appName = 'badrgo Ops Console';

  // Pages
  static const pageNotFound = 'Page not found';
  static const goHome = 'Go home';
  static const retry = 'Retry';

  // Sign-in
  static const signIn = 'Sign in';
  static const signInSubtitle = 'Use your operations account.';
  static const email = 'Email';
  static const password = 'Password';
  static const showPassword = 'Show password';
  static const hidePassword = 'Hide password';
  static const emailRequired = 'Enter your email.';
  static const emailInvalid = 'Enter a valid email address.';
  static const passwordRequired = 'Enter your password.';
  static const sessionExpired = 'Your session has ended. Please sign in again.';

  // Session
  static const restoringSession = 'Checking your session…';
  static const restoreFailed = "Couldn't check your session";
  static const signOut = 'Sign out';
  static const allCities = 'All cities';

  // Roles
  static const roleSuperAdmin = 'Super admin';
  static const roleOpsManager = 'Ops manager';
  static const roleDispatcher = 'Dispatcher';
  static const roleSupport = 'Support';
  static const roleViewer = 'Viewer';
  static const roleUnknown = 'Unknown role';

  // Console sections
  static const dashboard = 'Dashboard';
  static const trips = 'Trips';
  static const liveMap = 'Live map';
  static const alerts = 'Alerts';
  static const sectionComingSoon = 'This section is on its way.';

  // Dashboard
  static const dashboardLoadFailed = "Couldn't load the dashboard";
  static const kpiActiveTrips = 'Active trips';
  static const kpiCompleted = 'Completed';
  static const kpiCancellationRate = 'Cancellation rate';
  static const kpiRevenue = 'Revenue';
  static const kpiDrivers = 'Drivers available / on trip';
  static const kpiOpenAlerts = 'Open alerts';
  static const kpiLast24Hours = 'Last 24 hours';
  static const kpiOpenAlertsDetail = 'Not acknowledged yet';
  static const noValue = '—';
  static const live = 'Live';
  static const reconnecting = 'Reconnecting…';

  // Trips chart
  static const tripsOverTime = 'Trips over time';
  static const rangeLast24Hours = 'Last 24h';
  static const rangeLast7Days = 'Last 7 days';
  static const seriesTotal = 'Total';
  static const seriesCompleted = 'Completed';
  static const seriesCancelled = 'Cancelled';
  static const chartLoadFailed = "Couldn't load the chart";
  static const noTripsInRange = 'No trips in this period';

  static String seriesValue(String series, String count) => '$series: $count';

  // Trips list
  static const tripsLoadFailed = "Couldn't load trips";
  static const noTrips = 'No trips yet';
  static const noTripsMatch = 'No trips match these filters';
  static const clearFilters = 'Clear filters';
  static const searchTrips = 'Search trip id, address or rider';
  static const clearSearch = 'Clear search';
  static const anyDate = 'Any date';
  static const clearDates = 'Clear dates';
  static const loadMore = 'Load more';
  static const loadMoreFailed = "Couldn't load more trips";
  static const noDriverYet = 'No driver yet';
  static const tripRequested = 'Requested';
  static const tripAssigned = 'Assigned';
  static const tripInProgress = 'In progress';
  static const tripCompleted = 'Completed';
  static const tripCancelled = 'Cancelled';

  // Trip actions
  static const cancelTrip = 'Cancel trip';
  static const close = 'Close';
  static const reason = 'Reason';
  static const reasonLength = 'Enter 3 to 200 characters.';
  static const tripCancelledDone = 'Trip cancelled';

  static String tripCount(int count, String formatted) =>
      count == 1 ? '$formatted trip' : '$formatted trips';

  static String tripRoute(String pickup, String dropoff) =>
      '$pickup → $dropoff';

  static String tripDetails(
    String rider,
    String driver,
    String city,
    String requestedAt,
  ) => '$rider · $driver · $city · $requestedAt';

  static String dateRange(String from, String to) => '$from – $to';

  static String kpiActiveBreakdown(
    String requested,
    String assigned,
    String inProgress,
  ) => '$requested requested · $assigned assigned · $inProgress in progress';

  static String kpiCancelled(String cancelled) =>
      '$cancelled cancelled in 24 h';

  static String kpiDriverPair(String available, String onTrip) =>
      '$available / $onTrip';

  static String kpiDriversTotal(String total) => '$total drivers in total';

  static String updatedAt(String time) => 'Updated $time';

  // No access
  static const noAccess = "You don't have access to this page";
  static const noSections =
      'Your account has no console pages yet. Ask an administrator for '
      'access.';

  static String noAccessTo(String section) =>
      "Your role doesn't include $section. Ask an administrator if you need "
      'it.';

  // Connectivity
  static const offline =
      "You're offline. We'll reconnect automatically when the connection is "
      'back.';

  // Errors
  static const unexpectedError = 'Something went wrong. Please try again.';
  static const unexpectedResponse = 'Unexpected server response.';
  static const noConnection = 'Cannot reach the server. Check your connection.';
  static const requestCancelled = 'Request cancelled.';
}
