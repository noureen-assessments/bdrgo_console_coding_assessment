import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../connectivity/presentation/widgets/connection_restored_listener.dart';
import '../../../maintenance/presentation/widgets/maintenance_ended_listener.dart';
import '../bloc/auth/auth_bloc.dart';
import 'session_restore_view.dart';

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
      onRestored: () => _retryRestore(context),
      child: MaintenanceEndedListener(
        onEnded: () => _retryRestore(context),
        child: _buildSession(),
      ),
    );
  }

  void _retryRestore(BuildContext context) {
    context.read<AuthBloc>().add(const AuthConnectionRestored());
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
