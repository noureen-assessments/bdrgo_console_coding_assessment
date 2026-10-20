/// User-facing text. Kept in one place so it can move to localisation later.
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
  static const consolePlaceholder = 'Your console will appear here.';

  static String welcome(String name) => 'Welcome, $name';

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
