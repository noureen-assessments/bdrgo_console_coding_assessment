import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/alert.dart';
import '../bloc/critical_alerts/critical_alerts_bloc.dart';
import 'critical_alerts_dialog.dart';

class CriticalAlertBanner extends StatelessWidget {
  const CriticalAlertBanner({required this.navigatorKey, super.key});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CriticalAlertsBloc, CriticalAlertsState>(
      builder: (context, state) {
        if (!state.hasAlerts) return const SizedBox.shrink();
        return Semantics(
          liveRegion: true,
          child: Material(
            color: AppColors.alertCritical,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd,
                vertical: AppDimensions.spaceXs,
              ),
              child: Row(
                children: [
                  const Icon(
                    AppAssets.criticalAlert,
                    size: AppDimensions.iconMd,
                    color: AppColors.onAlertCritical,
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    child: Text(
                      _message(state.alerts),
                      style: AppStyles.criticalBannerText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    style: AppStyles.criticalBannerButton,
                    onPressed: () => _openDialog(context),
                    child: const Text(AppStrings.view),
                  ),
                  TextButton(
                    style: AppStyles.criticalBannerButton,
                    onPressed: () => context.read<CriticalAlertsBloc>().add(
                      const CriticalAlertsDismissed(),
                    ),
                    child: const Text(AppStrings.dismiss),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openDialog(BuildContext context) {
    final navigatorContext = navigatorKey.currentContext;
    if (navigatorContext == null) return;
    final bloc = context.read<CriticalAlertsBloc>();
    showDialog<void>(
      context: navigatorContext,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const CriticalAlertsDialog(),
      ),
    );
  }

  static String _message(List<Alert> alerts) {
    if (alerts.length == 1) {
      final alert = alerts.first;
      return AppStrings.alertSummary(alert.type.label, alert.message);
    }
    return AppStrings.criticalAlerts(alerts.length);
  }
}
