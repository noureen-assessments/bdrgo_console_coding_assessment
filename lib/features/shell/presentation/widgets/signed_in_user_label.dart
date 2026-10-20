import 'package:flutter/material.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/domain/entities/current_user.dart';
import '../../../auth/presentation/extensions/user_role_label.dart';

/// "Name · role · city".
class SignedInUserLabel extends StatelessWidget {
  const SignedInUserLabel({required this.user, super.key});

  final CurrentUser user;

  @override
  Widget build(BuildContext context) {
    final city = user.city?.name ?? AppStrings.allCities;
    return Text(
      '${user.name} · ${user.role.label} · $city',
      style: AppTextStyles.caption,
      overflow: TextOverflow.ellipsis,
    );
  }
}
