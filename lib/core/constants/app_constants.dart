// App Constants for Bihar Tourism
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Bihar Tourism';
  static const String appTagline = 'Experience the Heritage of Bihar';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://api.bihartourism.com/v1';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String experiencesCollection = 'experiences';
  static const String bookingsCollection = 'bookings';
  static const String guidesCollection = 'guides';
  static const String reviewsCollection = 'reviews';
  static const String categoriesCollection = 'categories';
  static const String wishlistCollection = 'wishlist';
  
  // Storage Buckets
  static const String experienceImagesBucket = 'experience_images';
  static const String userProfileBucket = 'user_profiles';
  static const String guideProfileBucket = 'guide_profiles';
  
  // Razorpay
  static const String razorpayKey = 'rzp_test_YOUR_KEY_HERE';
  
  // Google Maps
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Bihar Coordinates (Center)
  static const double biharCenterLat = 25.5941;
  static const double biharCenterLng = 85.1376;
  
  // Popular Locations in Bihar
  static const Map<String, Map<String, double>> biharLocations = {
    'Patna': {'lat': 25.5941, 'lng': 85.1376},
    'Bodh Gaya': {'lat': 24.6961, 'lng': 84.9869},
    'Nalanda': {'lat': 25.1357, 'lng': 85.4438},
    'Rajgir': {'lat': 25.0285, 'lng': 85.4177},
    'Vaishali': {'lat': 25.9854, 'lng': 85.1282},
    'Munger': {'lat': 25.3708, 'lng': 86.4735},
    'Bhagalpur': {'lat': 25.2425, 'lng': 86.9842},
    'Gaya': {'lat': 24.7914, 'lng': 85.0002},
  };
  
  // Experience Categories
  static const List<String> categories = [
    'Spiritual',
    'Heritage',
    'Food',
    'Nature',
    'Adventure',
    'Cultural',
  ];
  
  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingCancelled = 'cancelled';
  static const String bookingCompleted = 'completed';
  
  // User Roles
  static const String roleTourist = 'tourist';
  static const String roleGuide = 'guide';
  static const String roleAdmin = 'admin';
  
  // Pagination
  static const int pageSize = 10;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
  
  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
