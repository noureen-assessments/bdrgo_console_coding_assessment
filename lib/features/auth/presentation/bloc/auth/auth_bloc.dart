import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/current_user.dart';
import '../../../domain/usecases/restore_session_use_case.dart';
import '../../../domain/usecases/sign_out_use_case.dart';
import '../../../domain/usecases/watch_session_expiry_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// App-wide session state. The app shows sign-in, the console or a restore
/// screen from this state alone.
///
/// A `401` from any transport is handled once: the first one leaves
/// [AuthAuthenticated], so later ones from requests still in flight are
/// ignored and nothing calls the server again.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSessionUseCase restoreSession,
    required SignOutUseCase signOut,
    required WatchSessionExpiryUseCase watchSessionExpiry,
  }) : _restoreSession = restoreSession,
       _signOut = signOut,
       _watchSessionExpiry = watchSessionExpiry,
       super(const AuthRestoring()) {
    on<AuthStarted>(_onStarted);
    on<AuthRestoreRequested>(_onRestoreRequested);
    on<AuthSignedIn>((event, emit) => emit(AuthAuthenticated(event.user)));
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthConnectionRestored>((event, emit) {
      if (state is AuthRestoreFailed) add(const AuthRestoreRequested());
    });
  }

  final RestoreSessionUseCase _restoreSession;
  final SignOutUseCase _signOut;
  final WatchSessionExpiryUseCase _watchSessionExpiry;

  /// Checks the stored session, then listens for `401`s until the Bloc
  /// closes (Bloc cancels the stream on close).
  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    add(const AuthRestoreRequested());
    return emit.onEach(
      _watchSessionExpiry(const NoParams()),
      onData: (_) {
        final current = state;
        // A sign-out in progress already ends the session.
        if (current is AuthAuthenticated && !current.isSigningOut) {
          emit(const AuthUnauthenticated(sessionExpired: true));
        }
      },
    );
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
