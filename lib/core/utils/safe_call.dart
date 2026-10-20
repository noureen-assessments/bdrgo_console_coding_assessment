import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/app_strings.dart';
import '../errors/api_error_parser.dart';
import '../errors/failures.dart';

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
