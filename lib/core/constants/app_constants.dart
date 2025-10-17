class AppConstants {
  // App Information
  static const String appName = 'Eco-Trail';
  static const String appVersion = '1.0.0';

  // API Keys (These should be stored securely in environment variables)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String stripePublishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String eventsCollection = 'events';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';
  static const String ecoLocationsCollection = 'eco_locations';
  static const String sustainabilityTipsCollection = 'sustainability_tips';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String eventImagesPath = 'event_images';
  static const String locationImagesPath = 'location_images';

  // Map Configuration
  static const double defaultZoom = 12.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 3.0;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache Duration (in minutes)
  static const int cacheDuration = 30;
  static const int offlineCacheDuration = 1440; // 24 hours

  // Carbon Footprint Constants
  static const double carEmissionPerKm = 0.192; // kg CO2 per km
  static const double busEmissionPerKm = 0.089; // kg CO2 per km
  static const double trainEmissionPerKm = 0.041; // kg CO2 per km
  static const double planeEmissionPerKm = 0.285; // kg CO2 per km

  // Eco Certification Levels
  static const List<String> ecoCertificationLevels = [
    'Bronze',
    'Silver',
    'Gold',
    'Platinum',
  ];

  // Supported Languages
  static const List<String> supportedLanguages = [
    'en', // English
    'es', // Spanish
    'fr', // French
    'de', // German
    'it', // Italian
    'pt', // Portuguese
  ];

  // Event Categories
  static const List<String> eventCategories = [
    'Workshop',
    'Festival',
    'Tour',
    'Conference',
    'Volunteer',
    'Cultural',
    'Educational',
  ];

  // Location Types
  static const List<String> locationTypes = [
    'Eco Lodge',
    'Nature Trail',
    'Cultural Site',
    'Local Farm',
    'Sustainable Restaurant',
    'Green Hotel',
    'Wildlife Reserve',
    'Organic Market',
  ];
}
