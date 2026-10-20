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

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    add(const AuthRestoreRequested());
    return Future.wait([
      emit.onEach(
        _watchSessionExpiry(const NoParams()),
        onData: (_) {
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

  Future<void> _onAccessDenied(
    AuthAccessDenied event,
    Emitter<AuthState> emit,
  ) async {
    if (!_isActiveSession) return;
    final result = await _restoreSession(const NoParams());
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
