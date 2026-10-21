import 'package:latlong2/latlong.dart';

abstract final class MapConstants {
  static const tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const userAgentPackageName = 'com.badrgo.console';
  static const initialCenter = LatLng(25.2854, 51.5310);
  static const double initialZoom = 11;
  static const double minZoom = 3;
  static const double maxZoom = 18;
}
