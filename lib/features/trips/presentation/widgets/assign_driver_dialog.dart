import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../../domain/entities/trip_action.dart';
import '../../domain/entities/trip_summary.dart';
import '../bloc/available_drivers/available_drivers_bloc.dart';
import 'available_driver_list.dart';
import 'trip_action_dialog.dart';

class AssignDriverDialog extends StatelessWidget {
  const AssignDriverDialog({required this.trip, super.key});

  final TripSummary trip;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AvailableDriversBloc>()
            ..add(AvailableDriversRequested(trip.cityId)),
      child: _AssignDriverForm(trip: trip),
    );
  }
}

class _AssignDriverForm extends StatefulWidget {
  const _AssignDriverForm({required this.trip});

  final TripSummary trip;

  @override
  State<_AssignDriverForm> createState() => _AssignDriverFormState();
}

class _AssignDriverFormState extends State<_AssignDriverForm> {
  String? _driverId;
  bool _missingDriver = false;

  @override
  Widget build(BuildContext context) {
    return TripActionDialog(
      title: AppStrings.assignDriver,
      submitLabel: AppStrings.assign,
      onSubmit: _action,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AvailableDriverList(
            cityId: widget.trip.cityId,
            selectedId: _driverId,
            onSelected: (id) => setState(() {
              _driverId = id;
              _missingDriver = false;
            }),
          ),
          if (_missingDriver) ...[
            const SizedBox(height: AppDimensions.spaceSm),
            const MessageBanner(message: AppStrings.pickDriver),
          ],
        ],
      ),
    );
  }

  TripAction? _action() {
    final driverId = _driverId;
    if (driverId == null) {
      setState(() => _missingDriver = true);
      return null;
    }
    return AssignDriver(widget.trip.id, driverId: driverId);
  }
}
