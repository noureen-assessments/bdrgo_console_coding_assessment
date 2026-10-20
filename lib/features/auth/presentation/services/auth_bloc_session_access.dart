import '../../domain/entities/permission.dart';
import '../../domain/services/session_access.dart';
import '../bloc/auth/auth_bloc.dart';

final class AuthBlocSessionAccess implements SessionAccess {
  const AuthBlocSessionAccess(this._authBloc);

  final AuthBloc _authBloc;

  @override
  bool get isSignedIn => _authBloc.state is AuthAuthenticated;

  @override
  bool can(Permission permission) {
    final state = _authBloc.state;
    if (state is! AuthAuthenticated) return false;
    return state.user.permissions.can(permission);
  }
}
