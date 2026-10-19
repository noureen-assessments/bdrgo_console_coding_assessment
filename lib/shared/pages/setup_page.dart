import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../widgets/no_data_found_widget.dart';

/// Temporary landing page until the auth and shell features replace it.
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NoDataFoundWidget(
        icon: Icons.dashboard_outlined,
        title: AppStrings.appName,
        message: AppStrings.setupComplete,
      ),
    );
  }
}
