import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/sign_in/sign_in_bloc.dart';

class SignInStatusMessage extends StatelessWidget {
  const SignInStatusMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final signIn = context.watch<SignInBloc>().state;
    final sessionExpired = context.select(
      (AuthBloc bloc) => switch (bloc.state) {
        AuthUnauthenticated(:final sessionExpired) => sessionExpired,
        _ => false,
      },
    );

    final Widget? banner = switch (signIn) {
      SignInFailed(:final message) => MessageBanner(message: message),
      SignInIdle() when sessionExpired => const MessageBanner(
        message: AppStrings.sessionExpired,
        isError: false,
      ),
      _ => null,
    };
    if (banner == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      child: banner,
    );
  }
}
