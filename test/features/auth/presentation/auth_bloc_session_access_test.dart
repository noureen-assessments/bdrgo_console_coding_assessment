import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/services/auth_bloc_session_access.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_fixtures.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockAuthBloc authBloc;
  late AuthBlocSessionAccess access;

  setUp(() {
    authBloc = _MockAuthBloc();
    access = AuthBlocSessionAccess(authBloc);
  });

  test('signed in: answers from the user permissions', () {
    when(
      () => authBloc.state,
    ).thenReturn(AuthAuthenticated(userWith(supportPermissions)));

    expect(access.isSignedIn, isTrue);
    expect(access.can(TripPermission.refund), isTrue);
    expect(access.can(TripPermission.assign), isFalse);
  });

  test('signed out: no permission at all', () {
    when(() => authBloc.state).thenReturn(const AuthUnauthenticated());

    expect(access.isSignedIn, isFalse);
    expect(access.can(TripPermission.read), isFalse);
  });

  test('always reads the latest state (a role change applies at once)', () {
    when(
      () => authBloc.state,
    ).thenReturn(AuthAuthenticated(userWith(dispatcherPermissions)));
    expect(access.can(DriverPermission.track), isTrue);

    when(
      () => authBloc.state,
    ).thenReturn(AuthAuthenticated(userWith(viewerPermissions)));
    expect(access.can(DriverPermission.track), isFalse);
  });
}
