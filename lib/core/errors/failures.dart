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

final class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure(super.message, {super.statusCode});
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message, {super.statusCode});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.statusCode});
}

final class InvalidStateFailure extends Failure {
  const InvalidStateFailure(super.message, {super.statusCode});
}

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

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class CancelledFailure extends Failure {
  const CancelledFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.code, super.statusCode});

  final String? code;

  @override
  List<Object?> get props => [...super.props, code];
}
