import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sustainability_tip.dart';

class SustainabilityService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all sustainability tips
  static Stream<List<SustainabilityTip>> getSustainabilityTipsStream() {
    return _firestore
        .collection('sustainability_tips')
        .where('isVerified', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SustainabilityTip.fromFirestore(doc))
              .toList(),
        );
  }

  // Get tips by category
  static Future<List<SustainabilityTip>> getTipsByCategory(
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('sustainability_tips')
          .where('isVerified', isEqualTo: true)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SustainabilityTip.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tips by category: $e');
    }
  }

  // Search tips
  static Future<List<SustainabilityTip>> searchTips(String query) async {
    try {
      final snapshot = await _firestore
          .collection('sustainability_tips')
          .where('isVerified', isEqualTo: true)
          .get();

      final allTips = snapshot.docs
          .map((doc) => SustainabilityTip.fromFirestore(doc))
          .toList();

      if (query.isEmpty) return allTips;

      return allTips.where((tip) {
        return tip.title.toLowerCase().contains(query.toLowerCase()) ||
            tip.description.toLowerCase().contains(query.toLowerCase()) ||
            tip.category.toLowerCase().contains(query.toLowerCase()) ||
            tip.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search tips: $e');
    }
  }

  // Add carbon activity
  static Future<void> addCarbonActivity(CarbonActivity activity) async {
    try {
      await _firestore
          .collection('carbon_activities')
          .add(activity.toFirestore());
    } catch (e) {
      throw Exception('Failed to add carbon activity: $e');
    }
  }

  // Get user's carbon activities
  static Stream<List<CarbonActivity>> getUserCarbonActivities(String userId) {
    return _firestore
        .collection('carbon_activities')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CarbonActivity.fromFirestore(doc))
              .toList(),
        );
  }

  // Calculate carbon footprint summary
  static Future<CarbonFootprintSummary> calculateCarbonFootprint(
    String userId,
  ) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Get all user activities
      final snapshot = await _firestore
          .collection('carbon_activities')
          .where('userId', isEqualTo: userId)
          .get();

      final activities = snapshot.docs
          .map((doc) => CarbonActivity.fromFirestore(doc))
          .toList();

      // Calculate daily emissions
      final dailyActivities = activities
          .where((activity) => activity.date.isAfter(startOfDay))
          .toList();
      final dailyEmissions = dailyActivities.fold(
        0.0,
        (sum, activity) => sum + activity.emissions,
      );

      // Calculate weekly emissions
      final weeklyActivities = activities
          .where((activity) => activity.date.isAfter(startOfWeek))
          .toList();
      final weeklyEmissions = weeklyActivities.fold(
        0.0,
        (sum, activity) => sum + activity.emissions,
      );

      // Calculate monthly emissions
      final monthlyActivities = activities
          .where((activity) => activity.date.isAfter(startOfMonth))
          .toList();
      final monthlyEmissions = monthlyActivities.fold(
        0.0,
        (sum, activity) => sum + activity.emissions,
      );

      // Calculate total emissions
      final totalEmissions = activities.fold(
        0.0,
        (sum, activity) => sum + activity.emissions,
      );

      // Calculate emissions by category
      final emissionsByCategory = <String, double>{};
      for (final activity in activities) {
        emissionsByCategory[activity.type] =
            (emissionsByCategory[activity.type] ?? 0.0) + activity.emissions;
      }

      // Get recent activities (last 10)
      final recentActivities = activities.take(10).toList();

      return CarbonFootprintSummary(
        totalEmissions: totalEmissions,
        monthlyEmissions: monthlyEmissions,
        weeklyEmissions: weeklyEmissions,
        dailyEmissions: dailyEmissions,
        emissionsByCategory: emissionsByCategory,
        recentActivities: recentActivities,
        lastUpdated: now,
      );
    } catch (e) {
      throw Exception('Failed to calculate carbon footprint: $e');
    }
  }

  // Get carbon footprint summary stream
  static Stream<CarbonFootprintSummary> getCarbonFootprintStream(
    String userId,
  ) {
    return Stream.periodic(
      const Duration(minutes: 1),
    ).asyncMap((_) => calculateCarbonFootprint(userId));
  }

  // Calculate transport emissions
  static double calculateTransportEmissions({
    required double distance, // in km
    required String transportType,
    Map<String, dynamic>? metadata,
  }) {
    const emissionsFactors = {
      'car': 0.192, // kg CO2 per km
      'bus': 0.089, // kg CO2 per km
      'train': 0.041, // kg CO2 per km
      'plane': 0.285, // kg CO2 per km
      'bike': 0.0, // kg CO2 per km
      'walk': 0.0, // kg CO2 per km
    };

    final factor = emissionsFactors[transportType.toLowerCase()] ?? 0.0;
    return distance * factor;
  }

  // Calculate energy emissions
  static double calculateEnergyEmissions({
    required double consumption, // in kWh
    required String energyType,
  }) {
    const emissionsFactors = {
      'electricity': 0.4, // kg CO2 per kWh (varies by country)
      'gas': 0.2, // kg CO2 per kWh
      'solar': 0.0, // kg CO2 per kWh
      'wind': 0.0, // kg CO2 per kWh
    };

    final factor = emissionsFactors[energyType.toLowerCase()] ?? 0.0;
    return consumption * factor;
  }

  // Calculate food emissions
  static double calculateFoodEmissions({
    required String foodType,
    required double quantity, // in kg
  }) {
    const emissionsFactors = {
      'beef': 27.0, // kg CO2 per kg
      'lamb': 21.0, // kg CO2 per kg
      'cheese': 13.5, // kg CO2 per kg
      'pork': 12.1, // kg CO2 per kg
      'chicken': 6.9, // kg CO2 per kg
      'fish': 5.1, // kg CO2 per kg
      'eggs': 4.2, // kg CO2 per kg
      'rice': 4.0, // kg CO2 per kg
      'vegetables': 2.0, // kg CO2 per kg
      'fruits': 1.0, // kg CO2 per kg
    };

    final factor = emissionsFactors[foodType.toLowerCase()] ?? 1.0;
    return quantity * factor;
  }

  // Get tip categories
  static List<String> getTipCategories() {
    return [
      'Transportation',
      'Energy',
      'Food',
      'Waste',
      'Water',
      'Shopping',
      'Travel',
      'Home',
    ];
  }

  // Get transport types
  static List<String> getTransportTypes() {
    return ['car', 'bus', 'train', 'plane', 'bike', 'walk'];
  }

  // Get energy types
  static List<String> getEnergyTypes() {
    return ['electricity', 'gas', 'solar', 'wind'];
  }

  // Get food types
  static List<String> getFoodTypes() {
    return [
      'beef',
      'lamb',
      'cheese',
      'pork',
      'chicken',
      'fish',
      'eggs',
      'rice',
      'vegetables',
      'fruits',
    ];
  }
}
