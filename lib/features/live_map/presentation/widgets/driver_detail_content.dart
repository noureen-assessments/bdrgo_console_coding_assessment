import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../../../shared/widgets/detail_row.dart';
import '../../domain/entities/driver_detail.dart';
import 'driver_status_label.dart';
import 'driver_trip_section.dart';

class DriverDetailContent extends StatelessWidget {
  const DriverDetailContent({required this.driver, super.key});

  final DriverDetail driver;

  @override
  Widget build(BuildContext context) {
    final vehicle = driver.vehicle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(driver.name, style: AppTextStyles.title),
        const SizedBox(height: AppDimensions.spaceXxs),
        DriverStatusLabel(status: driver.status),
        const SizedBox(height: AppDimensions.spaceMd),
        DetailRow(label: AppStrings.labelPhone, value: driver.phone),
        DetailRow(
          label: AppStrings.labelRating,
          value: NumberFormatters.decimal(driver.rating),
        ),
        DetailRow(
          label: AppStrings.labelVehicle,
          value: AppStrings.vehicle(
            vehicle.make,
            vehicle.model,
            vehicle.color,
            vehicle.plate,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        DriverTripSection(trip: driver.currentTrip),
      ],
    );
  }
}
