import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../maintenance/presentation/widgets/maintenance_ended_listener.dart';
import '../bloc/trips/trips_bloc.dart';
import 'trip_filter_bar.dart';
import 'trips_body.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaintenanceEndedListener(
      onEnded: () =>
          context.read<TripsBloc>().add(const TripsRefreshRequested()),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<TripsBloc, TripsState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(context.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppDimensions.spaceSm,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      AppStrings.trips,
                      style: context.isMobile
                          ? AppTextStyles.headlineCompact
                          : AppTextStyles.headline,
                    ),
                    if (state is TripsLoaded)
                      Text(
                        AppStrings.tripCount(
                          state.page.totalCount,
                          NumberFormatters.count(state.page.totalCount),
                        ),
                        style: AppTextStyles.body,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                TripFilterBar(
                  filter: state.filter,
                  onChanged: (filter) =>
                      context.read<TripsBloc>().add(TripsFilterChanged(filter)),
                ),
              ],
            ),
          ),
          const Divider(height: AppDimensions.dividerThin),
          Expanded(child: TripsBody(state: state)),
        ],
      ),
    );
  }
}
