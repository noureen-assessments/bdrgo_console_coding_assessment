import 'package:flutter/material.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_detail.dart';
import 'trip_detail_row.dart';
import 'trip_detail_section.dart';

class TripDriverSection extends StatelessWidget {
  const TripDriverSection({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final name = trip.driverName;
    final phone = trip.driverPhone;
    final rating = trip.driverRating;
    final vehicle = trip.vehicle;
    if (name == null) {
      return const TripDetailSection(
        title: AppStrings.sectionDriver,
        children: [Text(AppStrings.noDriverYet, style: AppTextStyles.body)],
      );
    }
    return TripDetailSection(
      title: AppStrings.sectionDriver,
      children: [
        TripDetailRow(label: AppStrings.labelName, value: name),
        if (phone != null)
          TripDetailRow(label: AppStrings.labelPhone, value: phone),
        if (rating != null)
          TripDetailRow(
            label: AppStrings.labelRating,
            value: NumberFormatters.decimal(rating),
          ),
        if (vehicle != null)
          TripDetailRow(
            label: AppStrings.labelVehicle,
            value: AppStrings.vehicle(
              vehicle.make,
              vehicle.model,
              vehicle.color,
              vehicle.plate,
            ),
          ),
      ],
    );
  }
}
