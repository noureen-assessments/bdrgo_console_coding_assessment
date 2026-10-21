import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_detail.dart';
import '../../../../shared/widgets/detail_row.dart';
import 'trip_detail_section.dart';

class TripFareSection extends StatelessWidget {
  const TripFareSection({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final currency = trip.fare.currency;
    final refundReason = trip.refundReason;
    return TripDetailSection(
      title: AppStrings.sectionFare,
      children: [
        DetailRow(
          label: AppStrings.labelFare,
          value: NumberFormatters.currency(trip.fare.amount, currency),
        ),
        DetailRow(
          label: AppStrings.labelRefunded,
          value: NumberFormatters.currency(trip.refunded.amount, currency),
        ),
        DetailRow(
          label: AppStrings.labelLeftToRefund,
          value: NumberFormatters.currency(trip.remainingRefund, currency),
        ),
        if (refundReason != null)
          DetailRow(
            label: AppStrings.labelRefundReason,
            value: refundReason,
          ),
      ],
    );
  }
}
