import 'package:firebase_auth/firebase_auth.dart';

import '../utils/constants.dart';

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
    if (e.code == 'wrong-password' ||
        e.code == 'user-not-found' ||
        e.code == 'invalid-email') {
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

User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

Future<dynamic> isEmailAlreadyRegistered(String email) async {
  try {
    List<String> signInMethods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  } catch (e) {
    return Messages.emailCheckFailed;
  }
}
