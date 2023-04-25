class Messages {
  static const String signInFailed = "Sign in failed.";
  static const String signInFailedInvalidEmailPassword =
      "Invalid password or email.";

  static const String emailCheckFailed = "Email checking failed. Try again.";
  static const String signUpFailed = "Sign up failed.";
  static const String signUpSuccess = "User registered successfully.";
  static const String signUpFailedDuplicateEmail =
      "The account already exists for that email.";
  static const String signUpFailedWeakPassword =
      "The password provided is too weak..";

  static const String signOutFailed = "Sign out failed.";

  static const String unauthorized = "Unauthorized user.";

  static const String addNoteFailed = "Add note was failed";
  static const String addNoteSuccess = "Note added successfully";

  static const String getNotesFailed = "Getting notes failed";
  static const String getNoteFailed = "Getting note failed";
}

class Assets {
  static const String logo = 'assets/images/logo.png';
}

class RouteConstants {
  static const String homeRoute = '/';
  static const String signUpRoute = '/signUp';
  static const String noteViewRoute = '/note';
}
