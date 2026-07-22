/// Which journey an OTP verification belongs to, so the screen knows what
/// to do once the code is confirmed.
enum OtpFlow { register, resetPassword, changeMobileNumber }

/// Which journey a "create password" step belongs to.
enum PasswordFlow { register, resetPassword }

class OtpVerificationArgs {
  final String phone;
  final OtpFlow flow;

  /// Only required for [OtpFlow.changeMobileNumber], to finalize the change
  /// once the new number is verified.
  final String? nationalId;

  const OtpVerificationArgs({
    required this.phone,
    required this.flow,
    this.nationalId,
  });
}

class CreatePasswordArgs {
  final String phone;
  final PasswordFlow flow;

  const CreatePasswordArgs({required this.phone, required this.flow});
}
