import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/trip_status.dart';

class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge({required this.status, super.key});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: status.label, color: _statusColor(), width: AppDimensions.tripStatusBadgeWidth,);
  }

  Color _statusColor() {
    if (status == TripStatus.requested) return AppColors.tripRequested;
    if (status == TripStatus.assigned) return AppColors.tripAssigned;
    if (status == TripStatus.inProgress) return AppColors.tripInProgress;
    if (status == TripStatus.completed) return AppColors.tripCompleted;
    return AppColors.tripCancelled;
  }
}
