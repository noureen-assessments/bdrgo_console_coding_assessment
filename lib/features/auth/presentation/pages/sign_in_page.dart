import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/sign_in/sign_in_bloc.dart';
import '../widgets/sign_in_card.dart';

/// Provides a fresh [SignInBloc] per visit and hands a successful sign-in to
/// the app-wide [AuthBloc], which then routes into the console.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignInBloc>(),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (_, current) => current is SignInSucceeded,
      listener: (context, state) => context.read<AuthBloc>().add(
        AuthSignedIn((state as SignInSucceeded).user),
      ),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.pagePadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.formMaxWidth,
              ),
              child: const SignInCard(),
            ),
          ),
        ),
      ),
    );
  }
}
