import 'package:equatable/equatable.dart';

import '../constants/log_constants.dart';


sealed class Failure extends Equatable implements Exception {
  const Failure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => LogMessages.failure(runtimeType, statusCode, message);
}

/// `UNAUTHENTICATED` / 401: token missing, expired, revoked or user banned.
final class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure(super.message, {super.statusCode});
}

/// `FORBIDDEN` / 403: permission missing (e.g. role changed meanwhile).
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message, {super.statusCode});
}

/// `NOT_FOUND` / 404: also returned for resources in another city.
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.statusCode});
}

/// `INVALID_STATE` / 409:  cancelling a trip that just completed.
final class InvalidStateFailure extends Failure {
  const InvalidStateFailure(super.message, {super.statusCode});
}

/// `VALIDATION_FAILED` / 422, with the server's field details.
final class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    this.details = const {},
    super.statusCode,
  });

  final Map<String, Object?> details;

  @override
  List<Object?> get props => [...super.props, details];
}

/// `MAINTENANCE` / 503: the API is down for planned work or a restart.
final class MaintenanceFailure extends Failure {
  const MaintenanceFailure(
    super.message, {
    this.reason,
    this.retryAfter,
    this.since,
    super.statusCode,
  });


  final String? reason;
  final Duration? retryAfter;
  final DateTime? since;

  @override
  List<Object?> get props => [...super.props, reason, retryAfter, since];
}

/// The server could not be reached (offline, DNS, CORS, timeout).
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// The request was cancelled by the app, e.g. a superseded search.
final class CancelledFailure extends Failure {
  const CancelledFailure(super.message);
}

/// Any other server error or an unreadable response.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.code, super.statusCode});

  /// The raw server code when it is not one the app knows.
  final String? code;

  @override
  List<Object?> get props => [...super.props, code];
}
