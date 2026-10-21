import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../bloc/alerts/alerts_bloc.dart';
import 'alert_list.dart';

class AlertsBody extends StatelessWidget {
  const AlertsBody({required this.state, super.key});

  final AlertsState state;

  @override
  Widget build(BuildContext context) {
    final current = state;
    if (current is AlertsError) {
      return NoDataFoundWidget(
        icon: AppAssets.error,
        title: AppStrings.alertsLoadFailed,
        message: current.message,
        action: FilledButton(
          onPressed: () =>
              context.read<AlertsBloc>().add(const AlertsRefreshRequested()),
          child: const Text(AppStrings.retry),
        ),
      );
    }
    if (current is AlertsLoaded) {
      if (current.page.alerts.isEmpty) {
        return const NoDataFoundWidget(title: AppStrings.noAlerts);
      }
      return AlertList(
        state: current,
        onLoadMore: () =>
            context.read<AlertsBloc>().add(const AlertsNextPageRequested()),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}
