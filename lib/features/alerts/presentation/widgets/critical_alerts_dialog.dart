import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/dialog_title_bar.dart';
import '../bloc/critical_alerts/critical_alerts_bloc.dart';
import 'alert_list_tile.dart';

class CriticalAlertsDialog extends StatelessWidget {
  const CriticalAlertsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CriticalAlertsBloc, CriticalAlertsState>(
      listener: (context, state) {
        if (!state.hasAlerts) Navigator.pop(context);
      },
      builder: (context, state) {
        final alerts = state.alerts;
        final rows = <Widget>[];
        for (final alert in alerts) {
          if (rows.isNotEmpty) {
            rows.add(const Divider(height: AppDimensions.dividerThin));
          }
          rows.add(
            AlertListTile(
              key: ValueKey(alert.id),
              alert: alert,
              onAcknowledged: (acknowledged) => context
                  .read<CriticalAlertsBloc>()
                  .add(CriticalAlertsReceived(acknowledged)),
            ),
          );
        }
        return AlertDialog(
          title: DialogTitleBar(
            title: alerts.length == 1
                ? AppStrings.criticalAlert
                : AppStrings.criticalAlerts(alerts.length),
            onClose: () => Navigator.pop(context),
          ),
          titlePadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          scrollable: true,
          content: SizedBox(
            width: AppDimensions.formMaxWidth,
            child: Column(mainAxisSize: MainAxisSize.min, children: rows),
          ),
        );
      },
    );
  }
}
