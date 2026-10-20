import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_action.dart';
import '../../domain/entities/trip_summary.dart';
import '../validators/trip_action_validators.dart';
import 'trip_action_dialog.dart';

class RefundTripDialog extends StatefulWidget {
  const RefundTripDialog({required this.trip, super.key});

  final TripSummary trip;

  @override
  State<RefundTripDialog> createState() => _RefundTripDialogState();
}

class _RefundTripDialogState extends State<RefundTripDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final remaining = NumberFormatters.currency(
      trip.remainingRefund,
      trip.fare.currency,
    );
    return TripActionDialog(
      title: AppStrings.refundTrip,
      submitLabel: AppStrings.refundTrip,
      onSubmit: _action,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.refundable(remaining), style: AppTextStyles.body),
            const SizedBox(height: AppDimensions.spaceMd),
            TextFormField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) => TripActionValidators.refundAmount(
                value,
                trip.remainingRefund,
                remaining,
              ),
              decoration: InputDecoration(
                labelText: AppStrings.refundAmount,
                suffixText: trip.fare.currency,
                border: AppStyles.inputBorder,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            TextFormField(
              controller: _reason,
              minLines: AppDimensions.reasonMinLines,
              maxLines: AppDimensions.reasonMaxLines,
              maxLength: TripActionValidators.reasonMaxLength,
              validator: TripActionValidators.reason,
              decoration: const InputDecoration(
                labelText: AppStrings.reason,
                border: AppStyles.inputBorder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TripAction? _action() {
    if (!_formKey.currentState!.validate()) return null;
    return RefundTrip(
      widget.trip.id,
      amount: double.parse(_amount.text.trim()),
      reason: _reason.text.trim(),
    );
  }
}
