import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../../../shared/entities/money.dart';

class RevenueSummary extends StatelessWidget {
  const RevenueSummary({required this.revenue, super.key});

  final List<Money> revenue;

  @override
  Widget build(BuildContext context) {
    final values = <Widget>[];
    for (final money in revenue) {
      values.add(
        _value(NumberFormatters.currency(money.amount, money.currency)),
      );
    }
    if (values.isEmpty) {
      values.add(_value(AppStrings.noValue));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppStrings.kpiRevenue, style: AppStyles.mutedLabel),
        const SizedBox(height: AppDimensions.spaceXxs),
        const Text(AppStrings.kpiLast24Hours, style: AppTextStyles.caption),
        const SizedBox(height: AppDimensions.spaceSm),
        ...values,
      ],
    );
  }

  Widget _value(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, style: AppStyles.revenueValue),
    );
  }
}
