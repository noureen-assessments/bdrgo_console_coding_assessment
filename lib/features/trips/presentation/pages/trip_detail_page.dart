import 'package:flutter/material.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tripDetailTitle)),
      body: Center(child: Text(tripId, style: AppTextStyles.title)),
    );
  }
}
