import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../auth/domain/entities/permission.dart';
import '../../../auth/presentation/widgets/permission_gate.dart';
import '../../domain/entities/alert.dart';
import '../bloc/acknowledge_alert/acknowledge_alert_bloc.dart';

class AlertAcknowledgeButton extends StatelessWidget {
  const AlertAcknowledgeButton({
    required this.alertId,
    required this.onAcknowledged,
    super.key,
  });

  final String alertId;
  final ValueChanged<Alert> onAcknowledged;

  @override
  Widget build(BuildContext context) {
    return PermissionGate(
      permission: AlertPermission.acknowledge,
      child: BlocProvider(
        create: (_) => sl<AcknowledgeAlertBloc>(),
        child: BlocConsumer<AcknowledgeAlertBloc, AcknowledgeAlertState>(
          listener: (context, state) {
            if (state is AcknowledgeAlertDone) {
              onAcknowledged(state.alert);
              AppSnackBar.showSuccess(context, AppStrings.alertAcknowledgedDone);
            }
            if (state is AcknowledgeAlertFailed) {
              AppSnackBar.showError(context, state.failure.message);
            }
          },
          builder: (context, state) {
            if (state is AcknowledgeAlertSending) {
              return const SizedBox.square(
                dimension: AppDimensions.progressSm,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.progressStroke,
                ),
              );
            }
            return TextButton(
              onPressed: () => context.read<AcknowledgeAlertBloc>().add(
                AcknowledgeAlertSubmitted(alertId),
              ),
              child: const Text(AppStrings.acknowledge),
            );
          },
        ),
      ),
    );
  }
}
