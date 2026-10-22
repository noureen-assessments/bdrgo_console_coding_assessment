import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/kpis.dart';
import 'kpi_tile_grid.dart';
import 'live_status.dart';
import 'trip_chart_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({required this.kpis, required this.isLive, super.key});

  final Kpis kpis;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimensions.spaceMd,
            runSpacing: AppDimensions.spaceXs,
            children: [
              Text(
                AppStrings.dashboard,
                style: context.isMobile
                    ? AppTextStyles.headlineCompact
                    : AppTextStyles.headline,
              ),
              LiveStatus(isLive: isLive, updatedAt: kpis.generatedAt),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          KpiTileGrid(kpis: kpis),
          const SizedBox(height: AppDimensions.spaceXl),
          TripChartCard(revenue: kpis.revenue),
        ],
      ),
    );
  }
}
