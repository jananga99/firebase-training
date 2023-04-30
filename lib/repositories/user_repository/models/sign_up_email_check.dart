class SignUpEmailCheckResult {
  final bool success;
  final bool? isRegistered;
  final String? error;
  SignUpEmailCheckResult(
      {required this.success, this.error, this.isRegistered});
}
