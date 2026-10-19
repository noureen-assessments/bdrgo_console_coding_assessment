import 'package:flutter/widgets.dart';

import '../../config/theme/app_dimensions.dart';

/// Window-size helpers built on [MediaQuery.sizeOf], so widgets rebuild
/// when the browser window is resized. Mobile and web share one layout that
/// adapts at the [AppDimensions] breakpoints.
extension ResponsiveContext on BuildContext {
  double get windowWidth => MediaQuery.sizeOf(this).width;

  bool get isMobile => windowWidth < AppDimensions.tabletMinWidth;

  bool get isDesktop => windowWidth >= AppDimensions.desktopMinWidth;

  /// Padding around page content: tighter on phones.
  double get pagePadding =>
      isMobile ? AppDimensions.spaceMd : AppDimensions.spaceLg;
}
