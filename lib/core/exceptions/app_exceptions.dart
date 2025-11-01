/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() {
    if (code != null) {
      return 'AppException [$code]: $message';
    }
    return 'AppException: $message';
  }
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.details});

  factory NetworkException.noConnection() {
    return NetworkException(
      'No internet connection. Please check your network.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return NetworkException(
      'Request timed out. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError() {
    return NetworkException(
      'Server error. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }
}

/// API related exceptions
class ApiException extends AppException {
  final int? statusCode;

  ApiException(
    super.message, {
    this.statusCode,
    super.code,
    super.details,
  });

  factory ApiException.unauthorized() {
    return ApiException(
      'Unauthorized access. Please login again.',
      statusCode: 401,
      code: 'UNAUTHORIZED',
    );
  }

  factory ApiException.forbidden() {
    return ApiException(
      'Access forbidden.',
      statusCode: 403,
      code: 'FORBIDDEN',
    );
  }

  factory ApiException.notFound() {
    return ApiException(
      'Resource not found.',
      statusCode: 404,
      code: 'NOT_FOUND',
    );
  }

  factory ApiException.badRequest(String message) {
    return ApiException(
      message,
      statusCode: 400,
      code: 'BAD_REQUEST',
    );
  }

  factory ApiException.serverError() {
    return ApiException(
      'Server error. Please try again later.',
      statusCode: 500,
      code: 'SERVER_ERROR',
    );
  }

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException [$statusCode]: $message';
    }
    return 'ApiException: $message';
  }
}

/// FIXED: Renamed from DatabaseException to AppDatabaseException to avoid conflict with sqflite's DatabaseException
class AppDatabaseException extends AppException {
  AppDatabaseException(super.message, {super.code, super.details});

  factory AppDatabaseException.notFound(String entity) {
    return AppDatabaseException(
      '$entity not found in database.',
      code: 'NOT_FOUND',
    );
  }

  factory AppDatabaseException.insertFailed(String entity) {
    return AppDatabaseException(
      'Failed to insert $entity.',
      code: 'INSERT_FAILED',
    );
  }

  factory AppDatabaseException.updateFailed(String entity) {
    return AppDatabaseException(
      'Failed to update $entity.',
      code: 'UPDATE_FAILED',
    );
  }

  factory AppDatabaseException.deleteFailed(String entity) {
    return AppDatabaseException(
      'Failed to delete $entity.',
      code: 'DELETE_FAILED',
    );
  }

  factory AppDatabaseException.queryFailed([String? additionalInfo]) {
    return AppDatabaseException(
      additionalInfo ?? 'Database query failed.',
      code: 'QUERY_FAILED',
    );
  }
}

/// Storage related exceptions
class StorageException extends AppException {
  StorageException(super.message, {super.code, super.details});

  factory StorageException.readFailed() {
    return StorageException(
      'Failed to read from storage.',
      code: 'READ_FAILED',
    );
  }

  factory StorageException.writeFailed() {
    return StorageException(
      'Failed to write to storage.',
      code: 'WRITE_FAILED',
    );
  }

  factory StorageException.deleteFailed() {
    return StorageException(
      'Failed to delete from storage.',
      code: 'DELETE_FAILED',
    );
  }
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.code, super.details});

  factory AuthException.invalidCredentials() {
    return AuthException(
      'Invalid email or password.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.emailAlreadyExists() {
    return AuthException(
      'Email already registered.',
      code: 'EMAIL_EXISTS',
    );
  }

  factory AuthException.weakPassword() {
    return AuthException(
      'Password is too weak.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthException.userNotFound() {
    return AuthException(
      'User not found.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.tokenExpired() {
    return AuthException(
      'Session expired. Please login again.',
      code: 'TOKEN_EXPIRED',
    );
  }

  factory AuthException.notLoggedIn() {
    return AuthException(
      'User not logged in.',
      code: 'NOT_LOGGED_IN',
    );
  }
}

/// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    super.message, {
    this.fieldErrors,
    super.code,
    super.details,
  });

  factory ValidationException.invalidInput(String field, String error) {
    return ValidationException(
      'Invalid input',
      fieldErrors: {field: error},
      code: 'INVALID_INPUT',
    );
  }

  factory ValidationException.requiredField(String field) {
    return ValidationException(
      'Required field missing',
      fieldErrors: {field: '$field is required'},
      code: 'REQUIRED_FIELD',
    );
  }

  factory ValidationException.multipleErrors(Map<String, String> errors) {
    return ValidationException(
      'Multiple validation errors',
      fieldErrors: errors,
      code: 'MULTIPLE_ERRORS',
    );
  }
}

/// File/Media related exceptions
class MediaException extends AppException {
  MediaException(super.message, {super.code, super.details});

  factory MediaException.fileNotFound() {
    return MediaException(
      'File not found.',
      code: 'FILE_NOT_FOUND',
    );
  }

  factory MediaException.uploadFailed() {
    return MediaException(
      'Failed to upload file.',
      code: 'UPLOAD_FAILED',
    );
  }

  factory MediaException.invalidFormat() {
    return MediaException(
      'Invalid file format.',
      code: 'INVALID_FORMAT',
    );
  }

  factory MediaException.fileTooLarge(int maxSize) {
    return MediaException(
      'File size exceeds maximum allowed size of $maxSize bytes.',
      code: 'FILE_TOO_LARGE',
    );
  }
}

/// Permission related exceptions
class PermissionException extends AppException {
  PermissionException(super.message, {super.code, super.details});

  factory PermissionException.denied(String permission) {
    return PermissionException(
      '$permission permission denied.',
      code: 'PERMISSION_DENIED',
    );
  }

  factory PermissionException.permanentlyDenied(String permission) {
    return PermissionException(
      '$permission permission permanently denied. Please enable in settings.',
      code: 'PERMISSION_PERMANENTLY_DENIED',
    );
  }
}

/// Cache related exceptions
class CacheException extends AppException {
  CacheException(super.message, {super.code, super.details});

  factory CacheException.notFound() {
    return CacheException(
      'Data not found in cache.',
      code: 'NOT_FOUND',
    );
  }

  factory CacheException.saveFailed() {
    return CacheException(
      'Failed to save to cache.',
      code: 'SAVE_FAILED',
    );
  }
}

/// Generic unexpected exception
class UnexpectedException extends AppException {
  UnexpectedException([String? message, dynamic details])
      : super(
          message ?? 'An unexpected error occurred. Please try again.',
          code: 'UNEXPECTED_ERROR',
          details: details,
        );
}