import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../auth/domain/entities/permission.dart';
import '../../../auth/presentation/widgets/permission_gate.dart';
import '../../domain/entities/trip_summary.dart';
import '../bloc/trip_action/trip_action_bloc.dart';
import 'assign_driver_dialog.dart';
import 'cancel_trip_dialog.dart';
import 'refund_trip_dialog.dart';


class TripActions extends StatelessWidget {
  const TripActions({
    required this.trip,
    required this.onTripChanged,
    super.key,
  });

  final TripSummary trip;
  final VoidCallback onTripChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trip.canAssign)
          PermissionGate(
            permission: TripPermission.assign,
            child: IconButton(
              tooltip: AppStrings.assignDriver,
              icon: const ImageIcon(AssetImage(AppAssets.assignDriver)),
              onPressed: () => _open(
                context,
                AssignDriverDialog(trip: trip),
                AppStrings.driverAssigned,
              ),
            ),
          ),
        if (trip.canCancel)
          PermissionGate(
            permission: TripPermission.cancel,
            child: IconButton(
              tooltip: AppStrings.cancelTrip,
              icon: const Icon(AppAssets.cancelTrip),
              onPressed: () => _open(
                context,
                CancelTripDialog(trip: trip),
                AppStrings.tripCancelledDone,
              ),
            ),
          ),
        if (trip.canRefund)
          PermissionGate(
            permission: TripPermission.refund,
            child: IconButton(
              tooltip: AppStrings.refundTrip,
              icon: const Icon(AppAssets.refund),
              onPressed: () => _open(
                context,
                RefundTripDialog(trip: trip),
                AppStrings.refundIssued,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _open(
    BuildContext context,
    Widget dialog,
    String doneMessage,
  ) async {
    final outcome = await showDialog<TripActionState>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => sl<TripActionBloc>(),
        child: dialog,
      ),
    );
    if (!context.mounted) return;
    if (outcome is TripActionDone) {
      onTripChanged();
      AppSnackBar.showSuccess(context, doneMessage);
    } else if (outcome is TripActionFailed) {
      onTripChanged();
      AppSnackBar.showError(context, outcome.failure.message);
    }
  }
}
