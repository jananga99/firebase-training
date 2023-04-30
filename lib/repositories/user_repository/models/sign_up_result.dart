import 'package:project1/common/constants.dart';

class SignUpResult {
  final bool success;
  final String? error;
  SignUpResult({required this.success, this.error = Messages.signUpFailed});
}
