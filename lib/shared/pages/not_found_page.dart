import 'package:flutter/material.dart';

import '../../config/routing/route_names.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/no_data_found_widget.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoDataFoundWidget(
        icon: AppAssets.notFound,
        title: AppStrings.pageNotFound,
        message: path,
        action: FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.kRootPage, (_) => false),
          child: const Text(AppStrings.goHome),
        ),
      ),
    );
  }
}
