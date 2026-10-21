import 'dart:io';
import 'package:flutter/foundation.dart';

/// A custom [HttpOverrides] class that configures a global HTTP proxy.
/// This class is intended to route all HTTP requests through the Charles Proxy server.
/// Charles Proxy is used for monitoring and modifying HTTP requests for debugging purposes.
class CharlesProxyHttpOverrides extends HttpOverrides {
  /// The IP address of the Charles Proxy server.
  final String charlesIp;

  /// Constructor for [CharlesProxyHttpOverrides].
  /// [charlesIp] should be the IP address of the Charles Proxy server in your development environment.
  CharlesProxyHttpOverrides(this.charlesIp);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY $charlesIp:8888;";
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// Checks if the application is in debug mode and sets the global HTTP proxy to Charles Proxy if so.
/// This function is designed for use in a development environment only.
/// Replace <YOUR-IP-ADDRESS> with the IP address of your Charles Proxy server in [charlesIp]
void checkForCharlesProxy() {
  if (!kDebugMode) {
    return;
  }
  
  // Replace <YOUR-IP-ADDRESS> with the IP address of your Charles Proxy server.
  const String charlesIp = "<YOUR-IP-ADDRESS>";
  debugPrint('#CharlesProxyEnabled');
  HttpOverrides.global = CharlesProxyHttpOverrides(charlesIp);
}
