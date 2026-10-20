import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';


abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Marker for use cases that take no input.
final class NoParams {
  const NoParams();
}

/// A use case that streams values, e.g. connectivity or session events.
abstract interface class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}
