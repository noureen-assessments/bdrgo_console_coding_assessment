import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/widgets/dialog_title_bar.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../../domain/entities/trip_action.dart';
import '../bloc/trip_action/trip_action_bloc.dart';

class TripActionDialog extends StatelessWidget {
  const TripActionDialog({
    required this.title,
    required this.submitLabel,
    required this.content,
    required this.onSubmit,
    super.key,
  });

  final String title;
  final String submitLabel;
  final Widget content;
  final TripAction? Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripActionBloc, TripActionState>(
      listener: (context, state) {
        if (state is TripActionDone) Navigator.pop(context, state);
        if (state is TripActionFailed &&
            state.failure is InvalidStateFailure) {
          Navigator.pop(context, state);
        }
      },
      builder: (context, state) {
        final isSending = state is TripActionSending;
        return AlertDialog(
          title: DialogTitleBar(
            title: title,
            onClose: isSending ? null : () => Navigator.pop(context),
          ),
          titlePadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          scrollable: true,
          content: SizedBox(
            width: AppDimensions.formMaxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                if (state is TripActionFailed) ...[
                  const SizedBox(height: AppDimensions.spaceSm),
                  MessageBanner(message: state.failure.message),
                ],
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: isSending ? null : () => _submit(context),
              child: isSending
                  ? const SizedBox.square(
                      dimension: AppDimensions.progressSm,
                      child: CircularProgressIndicator(
                        strokeWidth: AppDimensions.progressStroke,
                      ),
                    )
                  : Text(submitLabel),
            ),
          ],
        );
      },
    );
  }

  void _submit(BuildContext context) {
    final action = onSubmit();
    if (action != null) {
      context.read<TripActionBloc>().add(TripActionSubmitted(action));
    }
  }
}
