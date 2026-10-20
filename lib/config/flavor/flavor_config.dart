// ignore_for_file: constant_identifier_names

import '../../core/constants/url_constants.dart';
import '../env/env.dart';

enum Flavor { DEV, ALPHA, PROD }

class FlavorValues {
  FlavorValues({required this.baseHost, required this.baseProtocol});

  factory FlavorValues.fromApiUrl(String apiUrl) {
    final uri = Uri.tryParse(apiUrl.trim());
    final validScheme =
        uri?.scheme == UrlConstants.http || uri?.scheme == UrlConstants.https;
    if (uri == null || !validScheme || uri.host.isEmpty) {
      throw ArgumentError.value(apiUrl, Env.apiUrlKey, Env.invalidApiUrl);
    }
    return FlavorValues(
      baseHost: '${uri.authority}${uri.path}',
      baseProtocol: uri.scheme,
    );
  }

  final String baseHost;
  final String baseProtocol;

  Uri get baseUri =>
      Uri.parse('$baseProtocol${UrlConstants.schemeSeparator}$baseHost');
}

class FlavorConfig {
  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance = FlavorConfig._internal(flavor, flavor.name, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  final Flavor flavor;
  final String name;
  final FlavorValues values;
  static late FlavorConfig _instance;

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PROD;
  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
  static bool isAlpha() => _instance.flavor == Flavor.ALPHA;
}
