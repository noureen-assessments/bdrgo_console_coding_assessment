import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../bloc/trip_detail/trip_detail_bloc.dart';
import 'trip_detail_content.dart';

class TripDetailBody extends StatelessWidget {
  const TripDetailBody({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailBloc, TripDetailState>(
      builder: (context, state) => switch (state) {
        TripDetailLoading() => const Center(child: CircularProgressIndicator()),
        TripDetailNotFound() => NoDataFoundWidget(
          icon: AppAssets.notFound,
          title: AppStrings.tripNotFound,
          message: AppStrings.tripNotFoundDetail,
          action: FilledButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text(AppStrings.backToTrips),
          ),
        ),
        final TripDetailError error => NoDataFoundWidget(
          icon: AppAssets.error,
          title: AppStrings.tripLoadFailed,
          message: error.message,
          action: FilledButton(
            onPressed: () => context.read<TripDetailBloc>().add(
              TripDetailRequested(tripId),
            ),
            child: const Text(AppStrings.retry),
          ),
        ),
        final TripDetailLoaded loaded => TripDetailContent(trip: loaded.trip),
      },
    );
  }
}
