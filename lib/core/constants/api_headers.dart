abstract final class ApiHeaders {
  static const authorization = 'Authorization';
  static const bearerPrefix = 'Bearer ';

  static String bearer(String token) => '$bearerPrefix$token';
}
