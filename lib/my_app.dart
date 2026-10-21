import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/flavor/flavor_config.dart';
import 'config/routing/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'features/alerts/presentation/widgets/critical_alerts_scope.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/widgets/auth_gate.dart';
import 'features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'features/connectivity/presentation/widgets/offline_banner.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    required this.router,
    required this.flavorConfig,
    required this.authBloc,
    required this.connectivityBloc,
    super.key,
  });

  final AppRouter router;
  final FlavorConfig flavorConfig;
  final AuthBloc authBloc;
  final ConnectivityBloc connectivityBloc;

  bool get _showBanner => flavorConfig.flavor != Flavor.PROD;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: connectivityBloc),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: router.navigatorKey,
        onGenerateRoute: router.onGenerateRoute,
        onGenerateInitialRoutes: router.onGenerateInitialRoutes,
        builder: _wrapNavigator,
      ),
    );
  }

  Widget _wrapNavigator(BuildContext context, Widget? navigator) {
    final app = Column(
      children: [
        const OfflineBanner(),
        CriticalAlertsScope(navigatorKey: router.navigatorKey),
        Expanded(
          child: AuthGate(
            onSignedIn: router.showConsole,
            onSignedOut: router.showSignIn,
            child: navigator ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
    if (!_showBanner) return app;
    return Banner(
      message: flavorConfig.name,
      location: BannerLocation.topEnd,
      child: app,
    );
  }
}
