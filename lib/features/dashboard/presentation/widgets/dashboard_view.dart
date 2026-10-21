import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../../../maintenance/presentation/widgets/maintenance_ended_listener.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/trip_chart/trip_chart_bloc.dart';
import 'dashboard_content.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaintenanceEndedListener(
      onEnded: () => _refresh(context),
      child: _buildContent(),
    );
  }

  void _refresh(BuildContext context) {
    context.read<DashboardBloc>().add(const DashboardRefreshRequested());
    context.read<TripChartBloc>().add(const TripChartRefreshRequested());
  }

  Widget _buildContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) => switch (state) {
        DashboardLoading() => const Center(child: CircularProgressIndicator()),
        final DashboardError error => NoDataFoundWidget(
          icon: AppAssets.error,
          title: AppStrings.dashboardLoadFailed,
          message: error.message,
          action: FilledButton(
            onPressed: () => context.read<DashboardBloc>().add(
              const DashboardRefreshRequested(),
            ),
            child: const Text(AppStrings.retry),
          ),
        ),
        final DashboardLoaded loaded => DashboardContent(
          kpis: loaded.kpis,
          isLive: loaded.isLive,
        ),
      },
    );
  }
}
