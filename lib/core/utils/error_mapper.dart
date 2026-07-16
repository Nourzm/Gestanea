class AuthErrorMapper {
  static String mapError(dynamic error) {
    final errorString = error. toString().toLowerCase();

    // User already exists
    if (errorString. contains('user already registered') ||
        errorString.contains('already registered') ||
        errorString.contains('23505') || // Postgres duplicate key
        errorString.contains('duplicate') ||
        errorString.contains('already exists')) {
      return 'account_exists';
    }

    // Invalid credentials
    if (errorString.contains('invalid login credentials') ||
        errorString.contains('invalid email or password')) {
      return 'Invalid email or password';
    }

    // Email not confirmed
    if (errorString.contains('email not confirmed')) {
      return 'Please verify your email first';
    }

    // Invalid OTP - map to user-friendly message
    if (errorString.contains('invalid token') ||
        errorString.contains('token has expired') ||
        errorString.contains('expired token') ||
        errorString.contains('otp') ||
        errorString.contains('verification failed') ||
        errorString.contains('invalid verification code')) {
      return 'Invalid or expired code';
    }

    // Network errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('noInternetConnection')) {
      return 'noInternetConnection';
    }

    // Rate limiting
    if (errorString. contains('rate limit') ||
        errorString.contains('too many')) {
      return 'Too many attempts. Please try again later';
    }

    // Supabase/Postgres specific errors - map to generic message
    if (errorString.contains('postgres') ||
        errorString.contains('supabase') ||
        errorString.contains('database') ||
        errorString.contains('sql') ||
        errorString.contains('23505') ||
        errorString.contains('23503') ||
        errorString.contains('42')) {
      return 'An error occurred. Please try again';
    }

    // Generic fallback - never show raw error messages
    return 'An error occurred. Please try again';
  }

  static bool isAccountExistsError(String mappedError) {
    return mappedError == 'account_exists';
  }
}