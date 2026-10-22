import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/current_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, CurrentUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, CurrentUser?>> restoreSession();

  Future<Either<Failure, Unit>> signOut();

  Stream<void> watchSessionExpiry();

  Stream<void> watchAccessDenied();
}
