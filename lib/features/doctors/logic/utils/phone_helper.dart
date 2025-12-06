import 'package:url_launcher/url_launcher.dart';

Future<bool> makePhoneCall(String phoneNumber) async {
  if (phoneNumber.isEmpty) {
    return false;
  }

  final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  final telUrl = Uri.parse('tel:$cleanNumber');

  try {
    final launched = await launchUrl(telUrl);
    return launched;
  } catch (e) {
    return false;
  }
}
