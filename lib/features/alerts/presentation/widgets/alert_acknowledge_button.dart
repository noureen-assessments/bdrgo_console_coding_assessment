import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/domain/entities/permission.dart';
import '../../../auth/presentation/widgets/permission_gate.dart';
import '../bloc/acknowledge_alert/acknowledge_alert_bloc.dart';

class AlertAcknowledgeButton extends StatelessWidget {
  const AlertAcknowledgeButton({required this.alertId, super.key});

  final String alertId;

  @override
  Widget build(BuildContext context) {
    return PermissionGate(
      permission: AlertPermission.acknowledge,
      child: BlocProvider(
        create: (_) => sl<AcknowledgeAlertBloc>(),
        child: BlocBuilder<AcknowledgeAlertBloc, AcknowledgeAlertState>(
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
