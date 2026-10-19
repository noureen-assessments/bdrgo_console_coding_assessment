import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/flavor/flavor_config.dart';
import 'config/routing/app_router.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/di/injection_container.dart';
import 'my_app.dart';

/// Shared bootstrap for every flavor entry point.
Future<void> mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean URLs (`/trips/42`) instead of `/#/trips/42`.
  usePathUrlStrategy();
  if (!FlavorConfig.isProduction() && kDebugMode) {
    Bloc.observer = const AppBlocObserver();
  }

  await initCore(config);
  runApp(MyApp(router: sl<AppRouter>(), flavorConfig: config));
}

// Dev:   flutter run -d chrome -t lib/main_dev.dart
// Alpha: flutter run -d chrome -t lib/main_alpha.dart
// Prod:  flutter build web --release -t lib/main_prod.dart
// Any flavor: --dart-define=API_URL=https://… (defaults to the sandbox)
