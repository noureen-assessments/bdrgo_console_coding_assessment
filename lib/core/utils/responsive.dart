import 'package:flutter/widgets.dart';

import '../../config/theme/app_dimensions.dart';

extension ResponsiveContext on BuildContext {
  double get windowWidth => MediaQuery.sizeOf(this).width;

  bool get isMobile => windowWidth < AppDimensions.tabletMinWidth;

  bool get isDesktop => windowWidth >= AppDimensions.desktopMinWidth;

  double get pagePadding =>
      isMobile ? AppDimensions.spaceMd : AppDimensions.spaceLg;
}
