import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/flavor/flavor_config.dart';
import 'config/routing/app_router.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'my_app.dart';

Future<void> mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  if (!FlavorConfig.isProduction() && kDebugMode) {
    Bloc.observer = const AppBlocObserver();
  }

  await initCore(config);
  runApp(
    MyApp(
      router: sl<AppRouter>(),
      flavorConfig: config,
      authBloc: sl<AuthBloc>()..add(const AuthStarted()),
      connectivityBloc: sl<ConnectivityBloc>()
        ..add(const ConnectivityStarted()),
    ),
  );
}
