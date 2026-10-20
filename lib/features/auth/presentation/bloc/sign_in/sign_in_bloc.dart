import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/current_user.dart';
import '../../../domain/usecases/sign_in_use_case.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

/// The sign-in form. Scoped to the sign-in page, so the typed password is
/// dropped as soon as the page closes.
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required SignInUseCase signIn})
    : _signIn = signIn,
      super(const SignInIdle()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  final SignInUseCase _signIn;

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state is SignInInProgress || state is SignInSucceeded) return;
    emit(const SignInInProgress());

    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );
    emit(
      result.fold(
        (failure) => SignInFailed(failure.message),
        SignInSucceeded.new,
      ),
    );
  }
}
