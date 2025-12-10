import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';
import '../models/city.dart';
import '../models/user.dart';
import '../models/trip.dart';
import '../utils/constants.dart';

/// REST API Service for TravelBuddy
class ApiService {
  final String baseUrl = AppConstants.restApiUrl;

  // ==================== Cities ====================

  Future<List<City>> getCities() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cities'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => City.fromJson(json)).toList();
      }
      throw Exception('Failed to load cities');
    } catch (e) {
      print('Error fetching cities: $e');
      rethrow;
    }
  }

  Future<City?> getCityByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cities/name/$name'));
      if (response.statusCode == 200) {
        return City.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching city: $e');
      return null;
    }
  }

  // ==================== Activities ====================

  Future<List<Activity>> getActivities() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/activities'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      }
      throw Exception('Failed to load activities');
    } catch (e) {
      print('Error fetching activities: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByCity(String city) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/activities/city/$city'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      }
      throw Exception('Failed to load activities for city');
    } catch (e) {
      print('Error fetching activities by city: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByType(String type) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/activities/type/$type'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      }
      throw Exception('Failed to load activities by type');
    } catch (e) {
      print('Error fetching activities by type: $e');
      rethrow;
    }
  }

  Future<List<String>> getActivityTypes({String? city}) async {
    try {
      final url = city != null
          ? '$baseUrl/activities/types?city=$city'
          : '$baseUrl/activities/types';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
      throw Exception('Failed to load activity types');
    } catch (e) {
      print('Error fetching activity types: $e');
      rethrow;
    }
  }

  Future<Activity> createActivity(Activity activity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/activities'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(activity.toJson()),
      );
      if (response.statusCode == 201) {
        return Activity.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to create activity');
    } catch (e) {
      print('Error creating activity: $e');
      rethrow;
    }
  }

  Future<void> deleteActivity(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/activities/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete activity');
      }
    } catch (e) {
      print('Error deleting activity: $e');
      rethrow;
    }
  }

  // ==================== Users ====================

  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );
      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to create user');
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$id'));
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // ==================== Trips ====================

  Future<List<Trip>> getTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Trip.fromJson(json)).toList();
      }
      throw Exception('Failed to load trips');
    } catch (e) {
      print('Error fetching trips: $e');
      rethrow;
    }
  }

  Future<List<Trip>> getTripsByUserId(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips/user/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Trip.fromJson(json)).toList();
      }
      throw Exception('Failed to load user trips');
    } catch (e) {
      print('Error fetching user trips: $e');
      rethrow;
    }
  }

  Future<Trip> createTrip(Trip trip) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trips'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(trip.toJson()),
      );
      if (response.statusCode == 201) {
        return Trip.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to create trip');
    } catch (e) {
      print('Error creating trip: $e');
      rethrow;
    }
  }

  Future<Trip> updateTrip(int id, Trip trip) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/trips/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(trip.toJson()),
      );
      if (response.statusCode == 200) {
        return Trip.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to update trip');
    } catch (e) {
      print('Error updating trip: $e');
      rethrow;
    }
  }

  Future<void> deleteTrip(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/trips/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete trip');
      }
    } catch (e) {
      print('Error deleting trip: $e');
      rethrow;
    }
  }
}
