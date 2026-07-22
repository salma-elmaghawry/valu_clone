/// Auth exceptions thrown by datasources, mapped to Failures in ErrorMapper.
class InvalidCredentialsException implements Exception {}

class PhoneAlreadyInUseException implements Exception {}

class UserNotFoundException implements Exception {}

class InvalidOtpException implements Exception {}
