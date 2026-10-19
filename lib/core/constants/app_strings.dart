/// User-facing text. Kept in one place so it can move to localisation later.
abstract final class AppStrings {
  static const appName = 'badrgo Ops Console';

  // Pages
  static const setupComplete = 'Project setup complete';
  static const pageNotFound = 'Page not found';
  static const goHome = 'Go home';

  // Errors
  static const unexpectedError = 'Something went wrong. Please try again.';
  static const unexpectedResponse = 'Unexpected server response.';
  static const noConnection = 'Cannot reach the server. Check your connection.';
  static const requestCancelled = 'Request cancelled.';
}
