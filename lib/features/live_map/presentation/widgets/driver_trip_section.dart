import 'package:flutter/material.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../../../shared/widgets/detail_row.dart';
import '../../../auth/domain/entities/permission.dart';
import '../../../auth/presentation/widgets/permission_gate.dart';
import '../../domain/entities/driver_trip.dart';

class DriverTripSection extends StatelessWidget {
  const DriverTripSection({required this.trip, super.key});

  final DriverTrip? trip;

  @override
  Widget build(BuildContext context) {
    final current = trip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.currentTrip, style: AppTextStyles.title),
        const SizedBox(height: AppDimensions.spaceXs),
        if (current == null)
          const Text(AppStrings.noCurrentTrip, style: AppTextStyles.body)
        else ...[
          DetailRow(label: AppStrings.labelPickup, value: current.pickupAddress),
          DetailRow(
            label: AppStrings.labelDropoff,
            value: current.dropoffAddress,
          ),
          DetailRow(
            label: AppStrings.labelFare,
            value: NumberFormatters.currency(
              current.fare.amount,
              current.fare.currency,
            ),
          ),
          PermissionGate(
            permission: TripPermission.read,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                RouteNames.kTripDetail,
                arguments: current.id,
              ),
              child: const Text(AppStrings.openTrip),
            ),
          ),
        ],
      ],
    );
  }
}
