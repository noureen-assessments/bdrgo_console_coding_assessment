import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/permission.dart';
import '../bloc/auth/auth_bloc.dart';

/// Guard widget: shows [child] only when the signed-in user has
/// [permission], otherwise [fallback] (nothing by default).
///
/// One mechanism for every permission check in the UI: action buttons
/// (`PermissionGate(permission: TripPermission.assign, child: …)`) and whole
/// pages (with a "no access" [fallback]). It rebuilds when the permissions
/// change, e.g. after a role change. Hiding a control is for the user; the
/// server still checks every request.
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
