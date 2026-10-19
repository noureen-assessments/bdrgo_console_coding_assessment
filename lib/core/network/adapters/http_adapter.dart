// Picks the platform's Dio adapter at compile time, so web-only code never
// reaches mobile builds.
export 'http_adapter_io.dart'
    if (dart.library.js_interop) 'http_adapter_web.dart';
