import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/permission.dart';
import '../bloc/auth/auth_bloc.dart';

class PermissionGate extends StatelessWidget {
  const PermissionGate({
    required this.permission,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    super.key,
  });

  final Permission permission;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final allowed = context.select((AuthBloc bloc) {
      final state = bloc.state;
      if (state is! AuthAuthenticated) return false;
      return state.user.permissions.can(permission);
    });
    return allowed ? child : fallback;
  }
}
