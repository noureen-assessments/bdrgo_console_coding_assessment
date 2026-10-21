import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logo,
      height: height,
      semanticsLabel: AppStrings.appName,
    );
  }
}
