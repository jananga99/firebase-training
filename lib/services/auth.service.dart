import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/utils/constants.dart';

Future<dynamic> signUp(
    {required String email, required String password}) async {
  late UserCredential credential;
  try {
    credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    late String errorMessage;
    if (e.code == 'weak-password') {
      errorMessage = Messages.signUpFailedWeakPassword;
    } else if (e.code == 'email-already-in-use') {
      errorMessage = Messages.signUpFailedDuplicateEmail;
    } else {
      errorMessage = Messages.signUpFailed;
    }
    return errorMessage;
  } catch (e) {
    return Messages.signUpFailed;
  }
}

Future<dynamic> signIn(
    {required String email, required String password}) async {
  try {
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential;
  } on FirebaseAuthException catch (e) {
    late String errorMessage;
    if (e.code == 'wrong-password') {
      errorMessage = Messages.signInFailedInvalidEmailPassword;
    } else {
      errorMessage = Messages.signInFailed;
    }
    return errorMessage;
  }
}

Future<dynamic> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    return Messages.signOutFailed;
  }
}
