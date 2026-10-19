import 'package:flutter/material.dart';

import 'config/flavor/flavor_config.dart';
import 'config/routing/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

/// Root widget. App-wide Blocs (session, connectivity) are provided here
/// with `MultiBlocProvider` once those features exist.
class MyApp extends StatelessWidget {
  const MyApp({required this.router, required this.flavorConfig, super.key});

  final AppRouter router;
  final FlavorConfig flavorConfig;

  bool get _showBanner => flavorConfig.flavor != Flavor.PROD;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: router.navigatorKey,
      onGenerateRoute: router.onGenerateRoute,
      onGenerateInitialRoutes: router.onGenerateInitialRoutes,
      builder: _showBanner ? _flavorBanner : null,
    );
  }

  Widget _flavorBanner(BuildContext context, Widget? child) => Banner(
    message: flavorConfig.name,
    location: BannerLocation.topEnd,
    child: child ?? const SizedBox.shrink(),
  );
}
