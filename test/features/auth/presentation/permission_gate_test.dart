import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/widgets/permission_gate.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_fixtures.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockAuthBloc authBloc;

  setUp(() => authBloc = _MockAuthBloc());

  Future<void> pumpGate(WidgetTester tester, AuthState state) async {
    when(() => authBloc.state).thenReturn(state);
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const PermissionGate(
            permission: TripPermission.assign,
            fallback: Text('No access'),
            child: Text('Assign driver'),
          ),
        ),
      ),
    );
  }

  AuthState signedInWith(Permissions permissions) =>
      AuthAuthenticated(userWith(permissions));

  testWidgets('dispatcher sees the assign action', (tester) async {
    await pumpGate(tester, signedInWith(dispatcherPermissions));

    expect(find.text('Assign driver'), findsOneWidget);
    expect(find.text('No access'), findsNothing);
  });

  testWidgets('viewer gets the fallback instead', (tester) async {
    await pumpGate(tester, signedInWith(viewerPermissions));

    expect(find.text('Assign driver'), findsNothing);
    expect(find.text('No access'), findsOneWidget);
  });

  testWidgets('support gets the fallback instead', (tester) async {
    await pumpGate(tester, signedInWith(supportPermissions));

    expect(find.text('Assign driver'), findsNothing);
  });

  testWidgets('signed out shows the fallback', (tester) async {
    await pumpGate(tester, const AuthUnauthenticated());

    expect(find.text('Assign driver'), findsNothing);
  });
}
