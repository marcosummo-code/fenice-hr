import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentLocation({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      final lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        return lastKnownPosition;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: timeout,
        ),
      ).timeout(timeout);
    } catch (e) {
      print('Errore nel recupero posizione: $e');
      return null;
    }
  }

  static String buildAddressText({
    required Iterable<String?> parts,
    required double lat,
    required double lng,
  }) {
    final normalized = parts
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (normalized.isNotEmpty) {
      return normalized.join(', ');
    }

    return 'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
  }

  static Future<String?> getAddressFromCoords(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lng&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'hr-app/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;

        final parts = <String?>[
          address?['road'] ?? address?['street'],
          address?['house_number'],
          address?['city'] ??
              address?['town'] ??
              address?['village'] ??
              address?['municipality'],
          address?['county'],
          address?['state'],
          address?['country'],
        ];

        return buildAddressText(parts: parts, lat: lat, lng: lng);
      }
    } catch (e) {
      print('Errore nel geocoding inverso: $e');
    }

    return null;
  }
}
