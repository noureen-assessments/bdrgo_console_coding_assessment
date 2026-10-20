abstract final class ApiErrorKeys {
  static const error = 'error';
  static const code = 'code';
  static const message = 'message';
  static const details = 'details';
  static const extensions = 'extensions';
  static const reason = 'reason';
  static const retryAfterSeconds = 'retryAfterSeconds';
  static const since = 'since';
}

/// Error codes the server sends in `error.code` / `extensions.code`.
abstract final class ApiErrorCodes {
  static const unauthenticated = 'UNAUTHENTICATED';
  static const forbidden = 'FORBIDDEN';
  static const notFound = 'NOT_FOUND';
  static const invalidState = 'INVALID_STATE';
  static const validationFailed = 'VALIDATION_FAILED';
  static const maintenance = 'MAINTENANCE';
}

/// HTTP statuses used as a fallback when the body carries no error code.
abstract final class ApiStatusCodes {
  static const unauthorized = 401;
  static const forbidden = 403;
  static const notFound = 404;
  static const conflict = 409;
  static const unprocessableEntity = 422;
  static const serviceUnavailable = 503;
}
