import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/session/session_expiry_notifier.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/current_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStorage tokenStorage,
    required SessionExpiryNotifier sessionExpiry,
  }) : _remote = remote,
       _tokenStorage = tokenStorage,
       _sessionExpiry = sessionExpiry;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  final SessionExpiryNotifier _sessionExpiry;

  @override
  Future<Either<Failure, CurrentUser>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await safeCall(() async {
      final token = await _remote.signIn(email: email, password: password);
      await _tokenStorage.saveToken(token);
      return _remote.fetchMe();
    });
    // A token without a profile is not a usable session.
    if (result.isLeft()) await _clearToken();
    return result;
  }

  /// Always asks the server: in web cookie mode there is no token to check
  /// locally. A `401` here just means "signed out", not an error.
  @override
  Future<Either<Failure, CurrentUser?>> restoreSession() async {
    final result = await safeCall(_remote.fetchMe);
    if (result case Left(value: UnauthenticatedFailure())) {
      await _clearToken();
      return const Right(null);
    }
    return result;
  }

  /// Offline or in maintenance the token stays, so the user stays signed in
  /// and can retry; the server must revoke it. A `401` means it is already
  /// revoked.
  @override
  Future<Either<Failure, Unit>> signOut() async {
    final result = await safeCall(_remote.signOut);
    if (result case Left(value: UnauthenticatedFailure()) || Right()) {
      await _clearToken();
      return const Right(unit);
    }
    return result.map((_) => unit);
  }

  @override
  Stream<void> watchSessionExpiry() =>
      _sessionExpiry.onExpired.asyncMap((_) => _clearToken());

  Future<void> _clearToken() => _tokenStorage.deleteToken();
}
