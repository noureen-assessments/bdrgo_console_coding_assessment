abstract final class ApiEndpoints {
  static const signIn = '/api/auth/sign-in/email';
  static const signOut = '/api/auth/sign-out';
  static const me = '/api/me';
  static const health = '/api/health';

  // Trip actions
  static String assignTrip(String tripId) => '/api/trips/$tripId/assign';
  static String cancelTrip(String tripId) => '/api/trips/$tripId/cancel';
  static String refundTrip(String tripId) => '/api/trips/$tripId/refund';
}
