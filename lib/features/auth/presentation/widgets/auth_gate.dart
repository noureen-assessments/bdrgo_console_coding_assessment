import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../connectivity/presentation/widgets/connection_restored_listener.dart';
import '../bloc/auth/auth_bloc.dart';
import 'session_restore_view.dart';

/// Wraps the app's navigator.
///
/// Until the stored session is known, the navigator is not built at all, so
/// the first route (e.g. a refreshed `/trips/42`) is resolved with the real
/// session. Afterwards it calls [onSignedIn] / [onSignedOut] on every
/// session change; the signed-out callback clears the page stack, which also
/// closes page-scoped Blocs and their realtime connections.
class AuthGate extends StatelessWidget {
  const AuthGate({
    required this.onSignedIn,
    required this.onSignedOut,
    required this.child,
    super.key,
  });

  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final Widget child;

  static bool _isResolved(AuthState state) =>
      state is AuthAuthenticated || state is AuthUnauthenticated;

  @override
  Widget build(BuildContext context) {
    return ConnectionRestoredListener(
      onRestored: () =>
          context.read<AuthBloc>().add(const AuthConnectionRestored()),
      child: _buildSession(),
    );
  }

  Widget _buildSession() {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          _isResolved(previous) &&
          _isResolved(current) &&
          previous.runtimeType != current.runtimeType,
      listener: (_, state) =>
          state is AuthAuthenticated ? onSignedIn() : onSignedOut(),
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (_, state) => switch (state) {
        AuthRestoring() => const SessionRestoreView(),
        AuthRestoreFailed(:final message) => SessionRestoreView(
          errorMessage: message,
        ),
        AuthAuthenticated() || AuthUnauthenticated() => child,
      },
    );
  }
}
