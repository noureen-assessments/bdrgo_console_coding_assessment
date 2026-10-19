import 'config/env/env.dart';
import 'config/flavor/flavor_config.dart';
import 'main_common.dart';

Future<void> main() => mainCommon(
  FlavorConfig(
    flavor: Flavor.PROD,
    values: FlavorValues.fromApiUrl(Env.apiUrl),
  ),
);
