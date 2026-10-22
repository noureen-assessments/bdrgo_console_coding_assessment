import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../bloc/driver_detail/driver_detail_bloc.dart';
import 'driver_detail_content.dart';

class DriverDetailPanel extends StatelessWidget {
  const DriverDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(AppAssets.clear),
                tooltip: AppStrings.close,
                onPressed: () => context.read<DriverDetailBloc>().add(
                  const DriverDetailDismissed(),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: BlocBuilder<DriverDetailBloc, DriverDetailState>(
                  builder: (context, state) => switch (state) {
                    DriverDetailClosed() => const SizedBox.shrink(),
                    DriverDetailLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    DriverDetailNotFound() => const MessageBanner(
                      message: AppStrings.driverNotFound,
                      detail: AppStrings.driverNotFoundDetail,
                      isError: false,
                    ),
                    final DriverDetailError error => _ErrorMessage(error),
                    final DriverDetailLoaded loaded => DriverDetailContent(
                      driver: loaded.driver,
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage(this.error);

  final DriverDetailError error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MessageBanner(
          message: AppStrings.driverLoadFailed,
          detail: error.message,
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        TextButton(
          onPressed: () => context.read<DriverDetailBloc>().add(
            DriverDetailRequested(error.driverId),
          ),
          child: const Text(AppStrings.retry),
        ),
      ],
    );
  }
}
