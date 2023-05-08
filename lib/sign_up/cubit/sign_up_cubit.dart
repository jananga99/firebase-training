import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../common/constants.dart';
import '../../repositories/repositories.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository _userRepository;
  SignUpCubit(this._userRepository) : super(const SignUpState());

  Future<void> checkEmail(String email) async {
    emit(state.copyWith(
        status: SignUpStatus.emailChecking, password: null, signUpError: null));
    final SignUpEmailCheckResult result =
        await _userRepository.isEmailAlreadyRegistered(email);
    if (result.success && result.isRegistered.runtimeType == bool) {
      if (!result.isRegistered!) {
        successCheckEmail(email);
      } else {
        failCheckEmail(Messages.signUpFailedDuplicateEmail);
      }
    } else {
      failCheckEmail(result.error ?? Messages.emailCheckFailed);
    }
  }

  void successCheckEmail(String email) {
    emit(state.copyWith(
        status: SignUpStatus.emailChecked,
        email: email,
        emailCheckError: null));
  }

  void failCheckEmail(String error) {
    emit(state.copyWith(
        status: SignUpStatus.emailCheckFailure,
        emailCheckError: error,
        email: null));
  }

  Future<void> signUp(String password) async {
    emit(state.copyWith(status: SignUpStatus.signUpLoading));
    if (state.email != null) {
      final SignUpResult result =
          await _userRepository.signUp(state.email!, password);
      if (result.success) {
        successSignUp();
      } else {
        failSignUp(result.error ?? Messages.signUpFailed);
      }
    } else {
      failSignUp(Messages.signUpFailed);
    }
  }

  void successSignUp() {
    emit(state.copyWith(status: SignUpStatus.signUpSucceeded));
  }

  void failSignUp(String error) {
    emit(
        state.copyWith(status: SignUpStatus.signUpFailure, signUpError: error));
  }

  void resetSignUp() {
    emit(state.copyWith(
        status: SignUpStatus.initial,
        email: null,
        password: null,
        emailCheckError: null,
        signUpError: null));
  }

  void resetPassword() {
    emit(state.copyWith(
        status: SignUpStatus.initial, password: null, signUpError: null));
  }

  void resetEmail() {
    emit(state.copyWith(status: SignUpStatus.initial, emailCheckError: null));
  }
}
