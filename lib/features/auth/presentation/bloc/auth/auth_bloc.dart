import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/current_user.dart';
import '../../../domain/usecases/restore_session_use_case.dart';
import '../../../domain/usecases/sign_out_use_case.dart';
import '../../../domain/usecases/watch_access_denied_use_case.dart';
import '../../../domain/usecases/watch_session_expiry_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// App-wide session state. The app shows sign-in, the console or a restore
/// screen from this state alone.
///
/// A `401` from any transport is handled once: the first one leaves
/// [AuthAuthenticated], so later ones from requests still in flight are
/// ignored and nothing calls the server again.
///
/// A `403` re-fetches `/api/me`, because the role may have changed on the
/// server; the console then rebuilds from the new permissions. A burst of
/// `403`s causes one re-fetch.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSessionUseCase restoreSession,
    required SignOutUseCase signOut,
    required WatchSessionExpiryUseCase watchSessionExpiry,
    required WatchAccessDeniedUseCase watchAccessDenied,
  }) : _restoreSession = restoreSession,
       _signOut = signOut,
       _watchSessionExpiry = watchSessionExpiry,
       _watchAccessDenied = watchAccessDenied,
       super(const AuthRestoring()) {
    on<AuthStarted>(_onStarted);
    on<AuthRestoreRequested>(_onRestoreRequested);
    on<AuthSignedIn>((event, emit) => emit(AuthAuthenticated(event.user)));
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthConnectionRestored>((event, emit) {
      if (state is AuthRestoreFailed) add(const AuthRestoreRequested());
    });
    on<AuthAccessDenied>(_onAccessDenied, transformer: droppable());
  }

  final RestoreSessionUseCase _restoreSession;
  final SignOutUseCase _signOut;
  final WatchSessionExpiryUseCase _watchSessionExpiry;
  final WatchAccessDeniedUseCase _watchAccessDenied;

  /// Checks the stored session, then listens for `401`s and `403`s until
  /// the Bloc closes (Bloc cancels the streams on close).
  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    add(const AuthRestoreRequested());
    return Future.wait([
      emit.onEach(
        _watchSessionExpiry(const NoParams()),
        onData: (_) {
          // A sign-out in progress already ends the session.
          if (_isActiveSession) {
            emit(const AuthUnauthenticated(sessionExpired: true));
          }
        },
      ),
      emit.onEach(
        _watchAccessDenied(const NoParams()),
        onData: (_) => add(const AuthAccessDenied()),
      ),
    ]);
  }

  /// Re-reads the user's permissions. If that fails (offline, maintenance)
  /// the current ones stay; the next `403` tries again.
  Future<void> _onAccessDenied(
    AuthAccessDenied event,
    Emitter<AuthState> emit,
  ) async {
    if (!_isActiveSession) return;
    final result = await _restoreSession(const NoParams());
    // Signed out meanwhile: there is nothing left to refresh.
    if (!_isActiveSession) return;
    result.fold((_) {}, (user) {
      if (user == null) {
        emit(const AuthUnauthenticated(sessionExpired: true));
      } else {
        emit(AuthAuthenticated(user));
      }
    });
  }

  bool get _isActiveSession {
    final current = state;
    return current is AuthAuthenticated && !current.isSigningOut;
  }

  Future<void> _onRestoreRequested(
    AuthRestoreRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthRestoring());
    final result = await _restoreSession(const NoParams());
    emit(
      result.fold(
        (failure) => AuthRestoreFailed(failure.message),
        (user) => user == null
            ? const AuthUnauthenticated()
            : AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final current = state;
    if (current is! AuthAuthenticated || current.isSigningOut) return;
    emit(AuthAuthenticated(current.user, isSigningOut: true));

    final result = await _signOut(const NoParams());
    emit(
      result.fold(
        (failure) =>
            AuthAuthenticated(current.user, signOutError: failure.message),
        (_) => const AuthUnauthenticated(),
      ),
    );
  }
}
