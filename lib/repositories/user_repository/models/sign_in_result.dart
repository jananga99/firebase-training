import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/utils/constants.dart';

class SignInResult {
  final User? user;
  final bool success;
  final String? error;
  SignInResult(
      {required this.success, this.user, this.error = Messages.signInFailed});
}
