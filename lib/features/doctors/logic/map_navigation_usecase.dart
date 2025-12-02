import 'package:url_launcher/url_launcher.dart';

class MapNavigationUseCase {
  Future<bool> openDirections(double latitude, double longitude) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
    );

    try {
      final launched = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
      return launched;
    } catch (e) {
      return false;
    }
  }
}
