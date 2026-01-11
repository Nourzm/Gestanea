
class EmailJSConfig {
  // EmailJS API endpoint
  static const String apiEndpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  // EmailJS Credentials
  static const String publicKey = 'QubP8fO5KchiGkj4q';
  static const String serviceId = 'service_h2k2r9b';
  static const String templateId = 'template_z0wqo42';

  // Template parameter names (these should match your EmailJS template)
  static const String paramName = 'name';
  static const String paramEmail = 'email';
  static const String paramSubject = 'title';
  static const String paramMessage = 'message';

  // Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);
}
