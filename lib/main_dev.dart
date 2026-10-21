import 'config/env/env.dart';
import 'config/flavor/flavor_config.dart';
import 'core/session/charles_proxy.dart';
import 'main_common.dart';

Future<void> main()  {
  //checkForCharlesProxy();
  return mainCommon(FlavorConfig(flavor: Flavor.DEV, values: FlavorValues.fromApiUrl(Env.apiUrl)),);
}
