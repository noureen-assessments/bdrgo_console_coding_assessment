import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/current_user.dart';
import '../repositories/auth_repository.dart';

final class SignInParams {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;
}

class SignInUseCase implements UseCase<CurrentUser, SignInParams> {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, CurrentUser>> call(SignInParams params) =>
      _repository.signIn(email: params.email.trim(), password: params.password);
}
