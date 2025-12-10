/// Configuration constants for the TravelBuddy app
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  // API Configuration
  // Change this to your server's IP address when running on a real device
  // API Configuration
  // Automatically detect if running on Android Emulator or other platforms
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/travelbuddy';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8080/travelbuddy';
      }
    } catch (e) {
      // Fallback for environments where Platform.isAndroid throws (e.g. Web catch-all)
      return 'http://localhost:8080/travelbuddy';
    }
    return 'http://localhost:8080/travelbuddy';
  }

  static String get restApiUrl => '$baseUrl/api';
  static String get soapUrl => '$baseUrl/ws/itinerary';

  // Activity Types
  static const List<String> activityTypes = [
    'landmark',
    'museum',
    'restaurant',
    'nature',
    'shopping',
    'nightlife',
    'experience',
  ];

  // Activity Type Labels (French)
  static const Map<String, String> activityTypeLabels = {
    'landmark': 'Monuments',
    'museum': 'Musées',
    'restaurant': 'Restaurants',
    'nature': 'Nature',
    'shopping': 'Shopping',
    'nightlife': 'Vie nocturne',
    'experience': 'Expériences',
  };

  // Preference Options
  static const List<String> preferences = ['relaxed', 'balanced', 'intensive'];

  // Preference Labels (French)
  static const Map<String, String> preferenceLabels = {
    'relaxed': 'Relaxé',
    'balanced': 'Équilibré',
    'intensive': 'Intensif',
  };

  // Budget Range
  static const double minBudget = 0;
  static const double maxBudget = 5000;

  // Duration Range
  static const int minDuration = 1;
  static const int maxDuration = 14;
}
