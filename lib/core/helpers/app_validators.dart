import 'package:easy_localization/easy_localization.dart';

class AppValidators {
  /// Special characters accepted by the password policy.
  static const String passwordSpecialChars = r'!#()"*\-/:?@\[\]^';

  /// Validates an Egyptian mobile number: 11 digits, starting with 010/011/012/015.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.login.phone_required'.tr();
    }
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value.trim())) {
      return 'auth.login.phone_invalid'.tr();
    }
    return null;
  }

  /// Validates a 14-digit national ID.
  static String? validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.national_id.required'.tr();
    }
    if (!RegExp(r'^\d{14}$').hasMatch(value.trim())) {
      return 'auth.national_id.invalid'.tr();
    }
    return null;
  }

  /// Login only requires a non-empty password (the strength policy is
  /// enforced when the password is first created).
  static String? validatePasswordRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.login.password_required'.tr();
    }
    return null;
  }

  /// Validates that the confirm password matches the password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'auth.login.password_required'.tr();
    }
    if (value != password) {
      return 'auth.create_password.mismatch'.tr();
    }
    return null;
  }

  /// Checks if password length is within the allowed 8–30 characters.
  static bool hasValidPasswordLength(String password) =>
      password.length >= 8 && password.length <= 30;

  /// Checks if password has both uppercase and lowercase letters and a digit.
  static bool hasMixedCaseAndDigit(String password) =>
      RegExp(r'(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(password);

  /// Checks that no character repeats more than 3 times in a row.
  static bool hasNoCharacterRepeatedMoreThan3Times(String password) {
    for (var i = 0; i + 3 < password.length; i++) {
      if (password[i] == password[i + 1] &&
          password[i + 1] == password[i + 2] &&
          password[i + 2] == password[i + 3]) {
        return false;
      }
    }
    return true;
  }

  /// Checks if password has at least one of the allowed special characters.
  static bool hasPasswordSpecialCharacter(String password) =>
      RegExp('[$passwordSpecialChars]').hasMatch(password);

  /// Combines every password-policy rule.
  static bool isStrongPassword(String password) =>
      hasValidPasswordLength(password) &&
      hasMixedCaseAndDigit(password) &&
      hasNoCharacterRepeatedMoreThan3Times(password) &&
      hasPasswordSpecialCharacter(password);
}
