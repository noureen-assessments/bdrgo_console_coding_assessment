import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/session/access_denied_notifier.dart';
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
    required AccessDeniedNotifier accessDenied,
  }) : _remote = remote,
       _tokenStorage = tokenStorage,
       _sessionExpiry = sessionExpiry,
       _accessDenied = accessDenied;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  final SessionExpiryNotifier _sessionExpiry;
  final AccessDeniedNotifier _accessDenied;

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
    if (result.isLeft()) await _clearToken();
    return result;
  }

  @override
  Future<Either<Failure, CurrentUser?>> restoreSession() async {
    final result = await safeCall(_remote.fetchMe);
    if (result case Left(value: UnauthenticatedFailure())) {
      await _clearToken();
      return const Right(null);
    }
    return result;
  }

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

  @override
  Stream<void> watchAccessDenied() => _accessDenied.onDenied;

  Future<void> _clearToken() => _tokenStorage.deleteToken();
}
