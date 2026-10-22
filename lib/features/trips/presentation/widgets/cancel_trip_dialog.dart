import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/trip_action.dart';
import '../../domain/entities/trip_summary.dart';
import '../validators/trip_action_validators.dart';
import 'trip_action_dialog.dart';

class CancelTripDialog extends StatefulWidget {
  const CancelTripDialog({required this.trip, super.key});

  final TripSummary trip;

  @override
  State<CancelTripDialog> createState() => _CancelTripDialogState();
}

class _CancelTripDialogState extends State<CancelTripDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TripActionDialog(
      title: AppStrings.cancelTrip,
      submitLabel: AppStrings.cancelTrip,
      onSubmit: _action,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reason,
          autofocus: true,
          minLines: AppDimensions.reasonMinLines,
          maxLines: AppDimensions.reasonMaxLines,
          maxLength: TripActionValidators.reasonMaxLength,
          validator: TripActionValidators.reason,
          decoration: const InputDecoration(
            labelText: AppStrings.reason,
            border: AppStyles.inputBorder,
          ),
        ),
      ),
    );
  }

  TripAction? _action() {
    if (!_formKey.currentState!.validate()) return null;
    return CancelTrip(widget.trip.id, reason: _reason.text.trim());
  }
}
