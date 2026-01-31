/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code});

  @override
  String toString() => 'ServerException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network/Connection exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});

  @override
  String toString() => 'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code});

  @override
  String toString() => 'CacheException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});

  @override
  String toString() => 'ValidationException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {super.code});

  @override
  String toString() => 'AuthenticationException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authorization exceptions
class AuthorizationException extends AppException {
  const AuthorizationException(super.message, {super.code});

  @override
  String toString() => 'AuthorizationException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});

  @override
  String toString() => 'NotFoundException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code});

  @override
  String toString() => 'TimeoutException: $message${code != null ? ' (Code: $code)' : ''}';
}
