import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Bihar cities for the app
class CityData {
  final String name;
  final double latitude;
  final double longitude;

  const CityData({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

/// Available cities in Bihar
const biharCities = [
  CityData(name: 'Patna', latitude: 25.5941, longitude: 85.1376),
  CityData(name: 'Bodh Gaya', latitude: 24.6961, longitude: 84.9869),
  CityData(name: 'Rajgir', latitude: 25.0285, longitude: 85.4177),
  CityData(name: 'Nalanda', latitude: 25.1357, longitude: 85.4438),
  CityData(name: 'Vaishali', latitude: 25.9854, longitude: 85.1282),
];

/// Storage keys
const _selectedCityKey = 'selected_city';
const _isFirstLaunchKey = 'is_first_launch';
const _locationPermissionAskedKey = 'location_permission_asked';

/// City provider state
class CityState {
  final String? selectedCity;
  final bool isFirstLaunch;
  final bool locationPermissionAsked;
  final bool isLoading;
  final String? error;

  const CityState({
    this.selectedCity,
    this.isFirstLaunch = true,
    this.locationPermissionAsked = false,
    this.isLoading = false,
    this.error,
  });

  CityState copyWith({
    String? selectedCity,
    bool? isFirstLaunch,
    bool? locationPermissionAsked,
    bool? isLoading,
    String? error,
  }) {
    return CityState(
      selectedCity: selectedCity ?? this.selectedCity,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      locationPermissionAsked:
          locationPermissionAsked ?? this.locationPermissionAsked,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// City provider notifier
class CityNotifier extends StateNotifier<CityState> {
  CityNotifier() : super(const CityState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedCity = prefs.getString(_selectedCityKey);
      final isFirstLaunch = prefs.getBool(_isFirstLaunchKey) ?? true;
      final locationPermissionAsked =
          prefs.getBool(_locationPermissionAskedKey) ?? false;

      state = CityState(
        selectedCity: selectedCity ?? 'Patna', // Default to Patna
        isFirstLaunch: isFirstLaunch,
        locationPermissionAsked: locationPermissionAsked,
        isLoading: false,
      );
    } catch (e) {
      state = CityState(
        selectedCity: 'Patna',
        isFirstLaunch: false,
        locationPermissionAsked: true,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Request location permission and detect city
  Future<bool> requestLocationAndDetectCity() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Mark that we've asked for location permission
      await prefs.setBool(_locationPermissionAskedKey, true);
      state = state.copyWith(locationPermissionAsked: true);

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(isLoading: false);
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Find nearest Bihar city
      final nearestCity = _findNearestCity(
        position.latitude,
        position.longitude,
      );

      await selectCity(nearestCity);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Find the nearest Bihar city to the given coordinates
  String _findNearestCity(double lat, double lng) {
    double minDistance = double.infinity;
    String nearestCity = 'Patna';

    for (final city in biharCities) {
      final distance = Geolocator.distanceBetween(
        lat,
        lng,
        city.latitude,
        city.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city.name;
      }
    }

    return nearestCity;
  }

  /// Select a city manually
  Future<void> selectCity(String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedCityKey, city);
      state = state.copyWith(selectedCity: city);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark first launch as complete
  Future<void> completeFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isFirstLaunchKey, false);
      state = state.copyWith(isFirstLaunch: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Get list of available cities
  List<String> get availableCities => biharCities.map((c) => c.name).toList();
}

/// Provider for city state
final cityProvider = StateNotifierProvider<CityNotifier, CityState>((ref) {
  return CityNotifier();
});

/// Provider for selected city (convenience)
final selectedCityNameProvider = Provider<String>((ref) {
  return ref.watch(cityProvider).selectedCity ?? 'Patna';
});

/// Provider for available cities list
final availableCitiesProvider = Provider<List<String>>((ref) {
  return biharCities.map((c) => c.name).toList();
});
