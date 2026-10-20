import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../../domain/entities/driver_location.dart';
import '../bloc/driver_detail/driver_detail_bloc.dart';
import 'driver_map.dart';
import 'driver_status_legend.dart';
import 'live_map_status.dart';

class LiveMapContent extends StatelessWidget {
  const LiveMapContent({
    required this.drivers,
    required this.isLive,
    super.key,
  });

  final List<DriverLocation> drivers;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DriverMap(
          drivers: drivers,
          onDriverTap: (id) =>
              context.read<DriverDetailBloc>().add(DriverDetailRequested(id)),
        ),
        Positioned(
          top: AppDimensions.spaceSm,
          left: AppDimensions.spaceSm,
          right: AppDimensions.spaceSm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LiveMapStatus(isLive: isLive),
              if (drivers.isEmpty) ...[
                const SizedBox(height: AppDimensions.spaceXs),
                const MessageBanner(
                  message: AppStrings.noDriversOnline,
                  isError: false,
                ),
              ],
            ],
          ),
        ),
        const Positioned(
          bottom: AppDimensions.spaceSm,
          left: AppDimensions.spaceSm,
          child: DriverStatusLegend(),
        ),
      ],
    );
  }
}
