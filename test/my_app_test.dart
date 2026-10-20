import 'dart:async';

import 'package:badrgo_console_assesment/config/flavor/flavor_config.dart';
import 'package:badrgo_console_assesment/config/routing/app_router.dart';
import 'package:badrgo_console_assesment/core/constants/app_assets.dart';
import 'package:badrgo_console_assesment/core/di/injection_container.dart';
import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/current_user.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/watch_session_expiry_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:badrgo_console_assesment/features/connectivity/domain/usecases/watch_connectivity_use_case.dart';
import 'package:badrgo_console_assesment/features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'package:badrgo_console_assesment/my_app.dart';
import 'package:badrgo_console_assesment/shared/use_cases/use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'features/auth/auth_fixtures.dart';
import 'features/fakes.dart';

class _MockWatchExpiry extends Mock implements WatchSessionExpiryUseCase {}

class _MockRestore extends Mock implements RestoreSessionUseCase {}

class _MockSignIn extends Mock implements SignInUseCase {}

class _MockSignOut extends Mock implements SignOutUseCase {}

/// The real Blocs, router and gate; only the use cases are mocked.
void main() {
  late _MockWatchExpiry watchExpiry;
  late _MockRestore restore;
  late _MockSignIn signIn;
  late _MockSignOut signOut;
  late FakeConnectivity connectivity;
  late StreamController<void> expired;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  setUp(() async {
    await sl.reset();
    watchExpiry = _MockWatchExpiry();
    restore = _MockRestore();
    signIn = _MockSignIn();
    signOut = _MockSignOut();
    connectivity = FakeConnectivity();
    expired = StreamController<void>.broadcast();
    when(() => watchExpiry(any())).thenAnswer((_) => expired.stream);
    sl.registerFactory(() => SignInBloc(signIn: signIn));
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    CurrentUser? restored,
    Flavor flavor = Flavor.PROD,
  }) async {
    when(() => restore(any())).thenAnswer((_) async => Right(restored));
    // Built inside the test so its events run in the test's fake-async zone.
    authBloc = AuthBloc(
      restoreSession: restore,
      signOut: signOut,
      watchSessionExpiry: watchExpiry,
    );
    addTearDown(authBloc.close);
    await tester.pumpWidget(
      MyApp(
        router: AppRouter(
          isSignedIn: () => authBloc.state is AuthAuthenticated,
        ),
        flavorConfig: FlavorConfig(
          flavor: flavor,
          values: FlavorValues.fromApiUrl('https://api.example.com'),
        ),
        authBloc: authBloc..add(const AuthStarted()),
        connectivityBloc: ConnectivityBloc(
          WatchConnectivityUseCase(connectivity),
        )..add(const ConnectivityStarted()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('signed out, a deep link shows sign-in', (tester) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = '/trips/42';
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await pumpApp(tester);

    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });

  testWidgets("shows the server's sign-in error", (tester) async {
    when(() => signIn(any())).thenAnswer(
      (_) async => const Left(ServerFailure('Invalid email or password')),
    );
    await pumpApp(tester);

    await tester.enterText(find.byType(TextFormField).first, 'a@b.co');
    await tester.enterText(find.byType(TextFormField).last, 'wrong');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Invalid email or password'), findsOneWidget);
  });

  testWidgets('a restored session opens the console with user, role and city', (
    tester,
  ) async {
    await pumpApp(tester, restored: dispatcher);

    expect(find.text('Dana Dispatcher · Dispatcher · Doha'), findsOneWidget);
  });

  testWidgets('adapts to the window: icon-only sign-out on a phone', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpApp(tester, restored: dispatcher);

    expect(find.text('Dana Dispatcher · Dispatcher · Doha'), findsOneWidget);
    expect(find.byTooltip('Sign out'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);

    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();

    expect(find.text('Sign out'), findsOneWidget);
    expect(find.byTooltip('Sign out'), findsNothing);
  });

  testWidgets('a 401 returns to sign-in and says why', (tester) async {
    await pumpApp(tester, restored: dispatcher);

    expired.add(null);
    await tester.pumpAndSettle();

    expect(
      find.text('Your session has ended. Please sign in again.'),
      findsOneWidget,
    );
    expect(find.text('Dana Dispatcher · Dispatcher · Doha'), findsNothing);
  });

  testWidgets('sign-out revokes and returns to sign-in', (tester) async {
    when(() => signOut(any())).thenAnswer((_) async => const Right(unit));
    await pumpApp(tester, restored: dispatcher);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    verify(() => signOut(any())).called(1);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('signed in, an unknown URL shows not found', (tester) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = '/nope';
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await pumpApp(tester, restored: dispatcher);

    expect(find.text('Page not found'), findsOneWidget);
  });

  testWidgets('shows the offline banner while offline', (tester) async {
    await pumpApp(tester);

    connectivity.set(online: false);
    await tester.pumpAndSettle();
    expect(find.byIcon(AppAssets.offline), findsOneWidget);

    connectivity.set(online: true);
    await tester.pumpAndSettle();
    expect(find.byIcon(AppAssets.offline), findsNothing);
  });

  testWidgets('shows the flavor banner except in prod', (tester) async {
    await pumpApp(tester, flavor: Flavor.DEV);
    expect(tester.widget<Banner>(find.byType(Banner)).message, 'DEV');
  });
}
