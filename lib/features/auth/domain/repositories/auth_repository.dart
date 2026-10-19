import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/current_user.dart';

abstract interface class AuthRepository {
  /// Signs in, stores the token and loads the user's profile.
  Future<Either<Failure, CurrentUser>> signIn({
    required String email,
    required String password,
  });

  /// The stored session's user, or `null` when there is no valid session.
  Future<Either<Failure, CurrentUser?>> restoreSession();

  /// Revokes the token on the server, then forgets it locally.
  Future<Either<Failure, Unit>> signOut();

  /// Emits whenever any transport receives a `401` for this session. The
  /// token is already forgotten locally; the server is not called again.
  Stream<void> watchSessionExpiry();
}
