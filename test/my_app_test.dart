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
import 'package:badrgo_console_assesment/features/auth/domain/usecases/watch_access_denied_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/watch_session_expiry_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/services/auth_bloc_session_access.dart';
import 'package:badrgo_console_assesment/features/connectivity/domain/usecases/watch_connectivity_use_case.dart';
import 'package:badrgo_console_assesment/features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'package:badrgo_console_assesment/features/dashboard/domain/entities/kpi_range.dart';
import 'package:badrgo_console_assesment/features/dashboard/domain/usecases/get_kpis_use_case.dart';
import 'package:badrgo_console_assesment/features/dashboard/domain/usecases/get_trip_series_use_case.dart';
import 'package:badrgo_console_assesment/features/dashboard/domain/usecases/watch_kpis_use_case.dart';
import 'package:badrgo_console_assesment/features/dashboard/domain/usecases/watch_live_status_use_case.dart';
import 'package:badrgo_console_assesment/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:badrgo_console_assesment/features/dashboard/presentation/bloc/trip_chart/trip_chart_bloc.dart';
import 'package:badrgo_console_assesment/features/trips/domain/entities/trip_filter.dart';
import 'package:badrgo_console_assesment/features/trips/domain/entities/trip_page_request.dart';
import 'package:badrgo_console_assesment/features/trips/domain/usecases/get_trip_use_case.dart';
import 'package:badrgo_console_assesment/features/trips/domain/usecases/get_trips_use_case.dart';
import 'package:badrgo_console_assesment/features/trips/domain/usecases/watch_trip_changes_use_case.dart';
import 'package:badrgo_console_assesment/features/trips/presentation/bloc/trips/trips_bloc.dart';
import 'package:badrgo_console_assesment/my_app.dart';
import 'package:badrgo_console_assesment/shared/use_cases/use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'features/auth/auth_fixtures.dart';
import 'features/fakes.dart';

class _MockWatchExpiry extends Mock implements WatchSessionExpiryUseCase {}

class _MockWatchDenied extends Mock implements WatchAccessDeniedUseCase {}

class _MockRestore extends Mock implements RestoreSessionUseCase {}

class _MockSignIn extends Mock implements SignInUseCase {}

class _MockSignOut extends Mock implements SignOutUseCase {}

class _MockGetKpis extends Mock implements GetKpisUseCase {}

class _MockGetTripSeries extends Mock implements GetTripSeriesUseCase {}

class _MockWatchKpis extends Mock implements WatchKpisUseCase {}

class _MockWatchLiveStatus extends Mock implements WatchLiveStatusUseCase {}

class _MockGetTrips extends Mock implements GetTripsUseCase {}

class _MockGetTrip extends Mock implements GetTripUseCase {}

class _MockWatchTripChanges extends Mock implements WatchTripChangesUseCase {}

void main() {
  late _MockWatchExpiry watchExpiry;
  late _MockWatchDenied watchDenied;
  late _MockRestore restore;
  late _MockSignIn signIn;
  late _MockSignOut signOut;
  late FakeConnectivity connectivity;
  late StreamController<void> expired;
  late StreamController<void> denied;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(KpiRange.last24Hours);
    registerFallbackValue(const TripPageRequest(filter: TripFilter()));
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  setUp(() async {
    await sl.reset();
    watchExpiry = _MockWatchExpiry();
    watchDenied = _MockWatchDenied();
    restore = _MockRestore();
    signIn = _MockSignIn();
    signOut = _MockSignOut();
    connectivity = FakeConnectivity();
    expired = StreamController<void>.broadcast();
    denied = StreamController<void>.broadcast();
    when(() => watchExpiry(any())).thenAnswer((_) => expired.stream);
    when(() => watchDenied(any())).thenAnswer((_) => denied.stream);
    sl.registerFactory(() => SignInBloc(signIn: signIn));
    _registerDashboard();
    _registerTrips();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    CurrentUser? restored,
    Flavor flavor = Flavor.PROD,
  }) async {
    when(() => restore(any())).thenAnswer((_) async => Right(restored));
    authBloc = AuthBloc(
      restoreSession: restore,
      signOut: signOut,
      watchSessionExpiry: watchExpiry,
      watchAccessDenied: watchDenied,
    );
    addTearDown(authBloc.close);
    await tester.pumpWidget(
      MyApp(
        router: AppRouter(session: AuthBlocSessionAccess(authBloc)),
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

  group('role-aware shell', () {
    void openUrl(WidgetTester tester, String url) {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = url;
      addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
      );
    }

    Finder menuItem(String label) => find.descendant(
      of: find.byType(NavigationRail),
      matching: find.text(label),
    );

    testWidgets('support sees no dashboard and no live map', (tester) async {
      await pumpApp(tester, restored: userWith(supportPermissions));

      expect(menuItem('Trips'), findsOneWidget);
      expect(menuItem('Alerts'), findsOneWidget);
      expect(menuItem('Dashboard'), findsNothing);
      expect(menuItem('Live map'), findsNothing);
    });

    testWidgets('dispatcher sees every section', (tester) async {
      await pumpApp(tester, restored: userWith(dispatcherPermissions));

      expect(menuItem('Dashboard'), findsOneWidget);
      expect(menuItem('Live map'), findsOneWidget);
    });

    testWidgets('a section the user may not open shows no access', (
      tester,
    ) async {
      openUrl(tester, '/live-map');

      await pumpApp(tester, restored: userWith(viewerPermissions));

      expect(find.text("You don't have access to this page"), findsOneWidget);
      expect(menuItem('Dashboard'), findsOneWidget);
    });

    testWidgets('a role change after a 403 updates the open page', (
      tester,
    ) async {
      openUrl(tester, '/live-map');
      await pumpApp(tester, restored: userWith(dispatcherPermissions));
      expect(find.text("You don't have access to this page"), findsNothing);

      when(
        () => restore(any()),
      ).thenAnswer((_) async => Right(userWith(viewerPermissions)));
      denied.add(null);
      await tester.pumpAndSettle();

      expect(find.text("You don't have access to this page"), findsOneWidget);
      expect(menuItem('Live map'), findsNothing);
    });
  });
}

void _registerDashboard() {
  final getKpis = _MockGetKpis();
  final watchKpis = _MockWatchKpis();
  final watchLiveStatus = _MockWatchLiveStatus();
  when(
    () => getKpis(any()),
  ).thenAnswer((_) async => const Left(NetworkFailure('offline')));
  when(() => watchKpis(any())).thenAnswer((_) => const Stream.empty());
  when(() => watchLiveStatus(any())).thenAnswer((_) => const Stream.empty());
  sl.registerFactory(
    () => DashboardBloc(
      getKpis: getKpis,
      watchKpis: watchKpis,
      watchLiveStatus: watchLiveStatus,
    ),
  );

  final getTripSeries = _MockGetTripSeries();
  when(
    () => getTripSeries(any()),
  ).thenAnswer((_) async => const Left(NetworkFailure('offline')));
  sl.registerFactory(() => TripChartBloc(getTripSeries: getTripSeries));
}

void _registerTrips() {
  final getTrips = _MockGetTrips();
  when(
    () => getTrips(any()),
  ).thenAnswer((_) async => const Left(NetworkFailure('offline')));
  final watchTripChanges = _MockWatchTripChanges();
  when(
    () => watchTripChanges(any()),
  ).thenAnswer((_) => const Stream.empty());
  sl.registerFactory(
    () => TripsBloc(
      getTrips: getTrips,
      getTrip: _MockGetTrip(),
      watchTripChanges: watchTripChanges,
    ),
  );
}
