import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import 'app_exceptions.dart';
import 'failures.dart';

/// Maps raw exceptions from any layer into typed, localized [Failure]s.
/// Every message goes through `.tr()` so the user always sees a localized error.
///
/// When the project uses a specific backend, add a dedicated branch BEFORE the
/// generic ones (see the Supabase example at the bottom of this file).
class ErrorMapper {
  static Failure map(dynamic error) {
    if (error is InvalidCredentialsException) {
      return InvalidCredentialsFailure(
        message: 'auth.errors.invalid_credentials'.tr(),
      );
    }

    if (error is PhoneAlreadyInUseException) {
      return PhoneAlreadyInUseFailure(message: 'auth.errors.phone_in_use'.tr());
    }

    if (error is UserNotFoundException) {
      return UserNotFoundFailure(message: 'auth.errors.account_not_found'.tr());
    }

    if (error is InvalidOtpException) {
      return InvalidOtpFailure(message: 'auth.errors.invalid_otp'.tr());
    }

    if (error is SocketException || error is TimeoutException) {
      return NetworkFailure(message: 'errors.network_error'.tr());
    }

    if (error is HttpException) {
      return ServerFailure(message: 'errors.server_error'.tr());
    }

    if (error is FormatException) {
      return ServerFailure(message: 'errors.server_error'.tr());
    }

    return UnexpectedFailure(message: 'errors.unexpected_error'.tr());
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXAMPLE: Supabase branch (place inside `map` above the generic branches)
// ─────────────────────────────────────────────────────────────────────────────
// if (error is supabase.AuthException) {
//   final msg = error.message.toLowerCase();
//   final code = error.code?.toLowerCase();
//
//   if (msg.contains('invalid login credentials')) {
//     return InvalidCredentialsFailure(message: 'auth.errors.invalid_credentials'.tr());
//   }
//   if (msg.contains('already registered') || msg.contains('user already exists')) {
//     return EmailAlreadyInUseFailure(message: 'auth.errors.email_in_use'.tr());
//   }
//   if (code == 'email_not_confirmed') {
//     return EmailNotConfirmedFailure(message: 'auth.errors.email_not_confirmed'.tr());
//   }
//   if (msg.contains('invalid token') || msg.contains('token expired') || msg.contains('otp')) {
//     return InvalidOtpFailure(message: 'auth.errors.invalid_otp'.tr());
//   }
//   if (code == 'over_email_send_rate_limit' || msg.contains('rate limit exceeded')) {
//     return TooManyRequestsFailure(message: 'auth.errors.rate_limit_exceeded'.tr());
//   }
//   if (msg.contains('network')) {
//     return NetworkFailure(message: 'errors.network_error'.tr());
//   }
//   return UnexpectedFailure(message: 'errors.unexpected_error'.tr());
// }
// if (error is supabase.PostgrestException) {
//   return ServerFailure(message: 'errors.server_error'.tr());
// }
