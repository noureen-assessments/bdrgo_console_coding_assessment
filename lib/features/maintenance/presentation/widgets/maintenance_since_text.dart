import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatters.dart';

class MaintenanceSinceText extends StatefulWidget {
  const MaintenanceSinceText({required this.since, super.key});

  final DateTime since;

  @override
  State<MaintenanceSinceText> createState() => _MaintenanceSinceTextState();
}

class _MaintenanceSinceTextState extends State<MaintenanceSinceText> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppStyles.elapsedTick, (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lasted = DateTime.now().difference(widget.since);
    return Text(
      AppStrings.maintenanceSince(
        DateFormatters.hour(widget.since),
        DateFormatters.duration(lasted),
      ),
      textAlign: TextAlign.center,
      style: AppTextStyles.caption,
    );
  }
}
