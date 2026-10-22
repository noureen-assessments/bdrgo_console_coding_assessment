import 'package:flutter/material.dart';

import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/alert_severity.dart';

class AlertSeverityBadge extends StatelessWidget {
  const AlertSeverityBadge({required this.severity, super.key});

  final AlertSeverity severity;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: severity.label, color: severity.color);
  }
}
