import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/map_constants.dart';
import '../../domain/entities/driver_location.dart';
import 'driver_marker.dart';

class DriverMap extends StatelessWidget {
  const DriverMap({
    required this.drivers,
    required this.onDriverTap,
    super.key,
  });

  final List<DriverLocation> drivers;
  final ValueChanged<String> onDriverTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: MapConstants.initialCenter,
        initialZoom: MapConstants.initialZoom,
        minZoom: MapConstants.minZoom,
        maxZoom: MapConstants.maxZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: MapConstants.tileUrl,
          userAgentPackageName: MapConstants.userAgentPackageName,
        ),
        MarkerLayer(
          markers: [
            for (final driver in drivers)
              Marker(
                key: ValueKey(driver.id),
                point: LatLng(driver.latitude, driver.longitude),
                width: AppDimensions.driverMarker,
                height: AppDimensions.driverMarker,
                child: DriverMarker(
                  driver: driver,
                  onTap: () => onDriverTap(driver.id),
                ),
              ),
          ],
        ),
        const SimpleAttributionWidget(
          source: Text(AppStrings.mapAttribution),
        ),
      ],
    );
  }
}
