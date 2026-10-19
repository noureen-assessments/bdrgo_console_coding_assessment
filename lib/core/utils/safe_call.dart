import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/app_strings.dart';
import '../errors/api_error_parser.dart';
import '../errors/failures.dart';

/// Runs a data-layer call and returns its result as `Either`.
///
/// Only expected errors are caught: [Failure] from the consumers, a raw
/// [DioException], and [FormatException] from DTO parsing. Programming errors
/// still surface so they are not hidden behind a generic message.
Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } on Failure catch (failure) {
    return Left(failure);
  } on DioException catch (exception) {
    return Left(ApiErrorParser.fromDioException(exception));
  } on FormatException {
    return const Left(ServerFailure(AppStrings.unexpectedResponse));
  }
}
