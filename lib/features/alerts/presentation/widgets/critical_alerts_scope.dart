import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../auth/domain/entities/permission.dart';
import '../../../auth/presentation/widgets/permission_gate.dart';
import '../bloc/critical_alerts/critical_alerts_bloc.dart';
import 'critical_alert_banner.dart';

class CriticalAlertsScope extends StatelessWidget {
  const CriticalAlertsScope({required this.navigatorKey, super.key});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return PermissionGate(
      permission: AlertPermission.read,
      child: BlocProvider(
        create: (_) =>
            sl<CriticalAlertsBloc>()..add(const CriticalAlertsStarted()),
        child: CriticalAlertBanner(navigatorKey: navigatorKey),
      ),
    );
  }
}
