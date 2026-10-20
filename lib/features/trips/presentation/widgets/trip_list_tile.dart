import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_change.dart';
import '../../domain/entities/trip_summary.dart';
import '../bloc/trips/trips_bloc.dart';
import 'trip_actions.dart';
import 'trip_status_badge.dart';

class TripListTile extends StatelessWidget {
  const TripListTile({required this.trip, this.mark, super.key});

  final TripSummary trip;

  final TripMark? mark;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: mark?.color,
      title: Text(
        AppStrings.tripRoute(trip.pickupAddress, trip.dropoffAddress),
        style: AppTextStyles.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        AppStrings.tripDetails(
          trip.riderName,
          trip.driverName ?? AppStrings.noDriverYet,
          trip.cityName,
          DateFormatters.dayTime(trip.requestedAt),
        ),
        style: AppTextStyles.caption,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TripActions(
            trip: trip,
            onTripChanged: () => context.read<TripsBloc>().add(
              TripsTripChanged(TripChange(tripId: trip.id, isNew: false)),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Column(
            mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            NumberFormatters.currency(trip.fare.amount, trip.fare.currency),
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppDimensions.spaceXxs),
          TripStatusBadge(status: trip.status),
            ],
          ),
        ],
      ),
    );
  }
}
