import 'dart:convert';
import 'package:http/http.dart' as http;

/// Custom exception for EmailJS errors
class EmailJSException implements Exception {
  final String message;
  final int? statusCode;

  EmailJSException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Service class to handle EmailJS email sending
class EmailJSService {
  static const String _serviceId = 'service_6khi3iw';
  static const String _templateId = 'template_10h7wvq';
  static const String _userId = '8iPZToI9Tv2TkpMSN';

  static const String _emailJsUrl =
      'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends an email using EmailJS
  ///
  /// Returns `true` if the email was sent successfully
  /// Throws [EmailJSException] if there's an error
  Future<bool> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      // Validate inputs
      if (name.trim().isEmpty ||
          email.trim().isEmpty ||
          subject.trim().isEmpty ||
          message.trim().isEmpty) {
        throw EmailJSException('All fields are required');
      }

      // Prepare the request body
      final emailData = {
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _userId,
        'template_params': {
          'name': name.trim(), // Matches {{name}}
          'email': email.trim(), // Matches {{email}}
          'title': subject.trim(), // Matches {{title}}
          'message': message.trim(), // Matches {{message}}
        },
      };

      // Debug logging
      print('Sending email with data: ${jsonEncode(emailData)}');
      print('Service ID: $_serviceId');
      print('Template ID: $_templateId');
      print('User ID: $_userId');

      // Send the request
      final response = await http
          .post(
            Uri.parse(_emailJsUrl),
            headers: {
              'Content-Type': 'application/json',
              'origin': 'http://localhost', // Required by EmailJS
            },
            body: jsonEncode(emailData),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw EmailJSException(
                'Request timed out. Please check your internet connection.',
              );
            },
          );

      // Handle the response
      if (response.statusCode == 200) {
        return true;
      } else {
        // Parse error message from response
        String errorMessage =
            'Failed to send email (Status: ${response.statusCode})';
        try {
          final responseBody = jsonDecode(response.body);
          errorMessage =
              responseBody['message'] ?? responseBody['error'] ?? errorMessage;

          // Add more context for debugging
          print('EmailJS Error Response: ${response.body}');
          print('Status Code: ${response.statusCode}');
        } catch (e) {
          // If parsing fails, show raw response
          print('Raw Error Response: ${response.body}');
          errorMessage = 'Error ${response.statusCode}: ${response.body}';
        }

        throw EmailJSException(errorMessage, response.statusCode);
      }
    } on EmailJSException {
      rethrow;
    } catch (e) {
      // Handle network errors or other exceptions
      throw EmailJSException(
        'Network error. Please check your internet connection and try again.',
      );
    }
  }

  /// Dispose method (if needed for future extensions)
  void dispose() {
    // Clean up resources if needed
  }
}
