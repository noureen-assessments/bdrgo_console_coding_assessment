import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';


abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

final class NoParams {
  const NoParams();
}

abstract interface class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}
