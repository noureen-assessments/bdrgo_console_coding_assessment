import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../../domain/entities/trip_filter.dart';
import '../bloc/trips/trips_bloc.dart';
import 'trip_list.dart';

class TripsBody extends StatelessWidget {
  const TripsBody({required this.state, super.key});

  final TripsState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      TripsLoading() => const Center(child: CircularProgressIndicator()),
      final TripsError error => NoDataFoundWidget(
        icon: AppAssets.error,
        title: AppStrings.tripsLoadFailed,
        message: error.message,
        action: FilledButton(
          onPressed: () => _showFilter(context, error.filter),
          child: const Text(AppStrings.retry),
        ),
      ),
      final TripsLoaded loaded when loaded.page.trips.isEmpty =>
        NoDataFoundWidget(
          title: loaded.filter.isEmpty
              ? AppStrings.noTrips
              : AppStrings.noTripsMatch,
          action: loaded.filter.isEmpty
              ? null
              : OutlinedButton(
                  onPressed: () => _showFilter(context, const TripFilter()),
                  child: const Text(AppStrings.clearFilters),
                ),
        ),
      final TripsLoaded loaded => TripList(
        state: loaded,
        onLoadMore: () =>
            context.read<TripsBloc>().add(const TripsNextPageRequested()),
      ),
    };
  }

  void _showFilter(BuildContext context, TripFilter filter) =>
      context.read<TripsBloc>().add(TripsFilterChanged(filter));
}
