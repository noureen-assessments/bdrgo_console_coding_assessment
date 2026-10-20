import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../bloc/available_drivers/available_drivers_bloc.dart';

class AvailableDriverList extends StatelessWidget {
  const AvailableDriverList({
    required this.cityId,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final String cityId;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableDriversBloc, AvailableDriversState>(
      builder: (context, state) => switch (state) {
        AvailableDriversLoading() => const Padding(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          child: Center(child: CircularProgressIndicator()),
        ),
        final AvailableDriversError error => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageBanner(
              message: AppStrings.driversLoadFailed,
              detail: error.message,
            ),
            TextButton(
              onPressed: () => context.read<AvailableDriversBloc>().add(
                AvailableDriversRequested(cityId),
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
        final AvailableDriversLoaded loaded when loaded.drivers.isEmpty =>
          const Text(AppStrings.noAvailableDrivers, style: AppTextStyles.body),
        final AvailableDriversLoaded loaded => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final driver in loaded.drivers)
              ListTile(
                selected: driver.id == selectedId,
                title: Text(driver.name),
                trailing: driver.id == selectedId
                    ? const Icon(AppAssets.selected)
                    : null,
                onTap: () => onSelected(driver.id),
              ),
          ],
        ),
      },
    );
  }
}
