import 'package:flutter/material.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';

/// Shown instead of a page the user's permissions don't include, e.g. a
/// bookmarked `/live-map` after a role change.
class NoAccessView extends StatelessWidget {
  /// For one section the user may not open.
  const NoAccessView.section(String this.sectionLabel, {super.key});

  /// For a user who may open no section at all.
  const NoAccessView.noSections({super.key}) : sectionLabel = null;

  final String? sectionLabel;

  @override
  Widget build(BuildContext context) {
    final label = sectionLabel;
    if (label == null) {
      return const NoDataFoundWidget(
        icon: AppAssets.noAccess,
        title: AppStrings.noAccess,
        message: AppStrings.noSections,
      );
    }
    return NoDataFoundWidget(
      icon: AppAssets.noAccess,
      title: AppStrings.noAccess,
      message: AppStrings.noAccessTo(label),
      action: FilledButton(
        onPressed: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RouteNames.kRootPage, (_) => false),
        child: const Text(AppStrings.goHome),
      ),
    );
  }
}
