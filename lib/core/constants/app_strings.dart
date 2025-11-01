class AppStrings {
  // App Info
  static const String appName = 'Gestanea';
  static const String appVersion = '1.0.0';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorUnauthorized = 'Unauthorized access. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorValidation = 'Please check your input and try again.';

  // Validation Messages
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email address';
  static const String validationPhone = 'Please enter a valid phone number';
  static const String validationPassword = 'Password must be at least 8 characters';
  static const String validationPasswordMatch = 'Passwords do not match';
  static const String validationDate = 'Please enter a valid date';

  // Common Actions
  static const String actionSave = 'Save';
  static const String actionCancel = 'Cancel';
  static const String actionDelete = 'Delete';
  static const String actionEdit = 'Edit';
  static const String actionConfirm = 'Confirm';
  static const String actionContinue = 'Continue';
  static const String actionBack = 'Back';
  static const String actionNext = 'Next';
  static const String actionDone = 'Done';
  static const String actionRetry = 'Retry';
  static const String actionOk = 'OK';
  static const String actionYes = 'Yes';
  static const String actionNo = 'No';

  // Status Messages
  static const String statusLoading = 'Loading...';
  static const String statusSuccess = 'Success!';
  static const String statusFailed = 'Failed';
  static const String statusProcessing = 'Processing...';
  static const String statusSaved = 'Saved successfully';
  static const String statusDeleted = 'Deleted successfully';
  static const String statusUpdated = 'Updated successfully';

  // Empty States
  static const String emptyData = 'No data available';
  static const String emptySearch = 'No results found';
  static const String emptyNotifications = 'No notifications';

  // Date Formats
  static const String dateFormatShort = 'MMM dd, yyyy';
  static const String dateFormatLong = 'MMMM dd, yyyy';
  static const String dateFormatTime = 'hh:mm a';
  static const String dateFormatDateTime = 'MMM dd, yyyy hh:mm a';

  // Database
  static const String dbName = 'gestanea.db';
  static const int dbVersion = 1;

  // Preferences Keys
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyLocale = 'locale';
  static const String prefKeyOnboardingCompleted = 'onboarding_completed';
  static const String prefKeyUserToken = 'user_token';
  static const String prefKeyUserId = 'user_id';
  static const String prefKeyUserEmail = 'user_email';
  static const String prefKeyUserName = 'user_name';

  // API
  static const String apiBaseUrl = 'https://api.gestanea.com'; // Replace with actual API URL
  static const int apiTimeoutSeconds = 30;
  static const String apiContentType = 'application/json';

  // Notification Channels
  static const String notificationChannelId = 'gestanea_notifications';
  static const String notificationChannelName = 'Gestanea Notifications';
  static const String notificationChannelDescription = 'Notifications for pregnancy tracking and baby care';
}
