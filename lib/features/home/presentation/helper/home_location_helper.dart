import 'package:geolocator/geolocator.dart';

class HomeLocationResult {
  final double latitude;
  final double longitude;
  final bool isFromGps;
  final String? message;

  const HomeLocationResult({
    required this.latitude,
    required this.longitude,
    required this.isFromGps,
    this.message,
  });
}

class HomeLocationHelper {
  const HomeLocationHelper._();

  static const double fallbackLatitude = 27.690162;
  static const double fallbackLongitude = 85.350253;

  static Future<HomeLocationResult> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const HomeLocationResult(
          latitude: fallbackLatitude,
          longitude: fallbackLongitude,
          isFromGps: false,
          message: 'Location service is disabled',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const HomeLocationResult(
          latitude: fallbackLatitude,
          longitude: fallbackLongitude,
          isFromGps: false,
          message: 'Location permission denied',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const HomeLocationResult(
          latitude: fallbackLatitude,
          longitude: fallbackLongitude,
          isFromGps: false,
          message: 'Location permission permanently denied',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return HomeLocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        isFromGps: true,
      );
    } catch (e) {
      return HomeLocationResult(
        latitude: fallbackLatitude,
        longitude: fallbackLongitude,
        isFromGps: false,
        message: 'Failed to get location: $e',
      );
    }
  }
}
