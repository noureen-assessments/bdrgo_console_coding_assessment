import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/live_indicator.dart';
import '../bloc/alerts/alerts_bloc.dart';
import 'alerts_body.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertsBloc, AlertsState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(context.pagePadding),
            child: Wrap(
              spacing: AppDimensions.spaceSm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  AppStrings.alerts,
                  style: context.isMobile
                      ? AppTextStyles.headlineCompact
                      : AppTextStyles.headline,
                ),
                LiveIndicator(isLive: state.isLive),
              ],
            ),
          ),
          const Divider(height: AppDimensions.dividerThin),
          Expanded(child: AlertsBody(state: state)),
        ],
      ),
    );
  }
}
