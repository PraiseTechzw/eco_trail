import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sustainability_tip.dart';

class DemoTipsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample sustainability tips data
  static final List<Map<String, dynamic>> _sampleTips = [
    {
      'title': 'Use Public Transportation',
      'description':
          'Opt for buses, trains, or subways instead of driving alone. Public transportation can reduce your carbon footprint by up to 45% compared to driving a car.',
      'category': 'Transportation',
      'difficulty': 'Easy',
      'estimatedImpact': 25,
      'tags': ['transport', 'public', 'commute', 'environment'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Switch to LED Light Bulbs',
      'description':
          'Replace incandescent bulbs with LED lights. LEDs use 75% less energy and last 25 times longer than traditional bulbs.',
      'category': 'Energy',
      'difficulty': 'Easy',
      'estimatedImpact': 15,
      'tags': ['energy', 'lighting', 'home', 'efficiency'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Reduce Meat Consumption',
      'description':
          'Try having meatless meals a few times a week. Plant-based diets can reduce your carbon footprint by up to 50%.',
      'category': 'Food',
      'difficulty': 'Medium',
      'estimatedImpact': 40,
      'tags': ['food', 'diet', 'vegetarian', 'health'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Compost Food Waste',
      'description':
          'Start composting your food scraps instead of throwing them away. Composting reduces methane emissions and creates nutrient-rich soil.',
      'category': 'Waste',
      'difficulty': 'Medium',
      'estimatedImpact': 20,
      'tags': ['waste', 'compost', 'garden', 'recycling'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Install Solar Panels',
      'description':
          'Consider installing solar panels on your roof to generate clean, renewable energy for your home.',
      'category': 'Energy',
      'difficulty': 'Hard',
      'estimatedImpact': 100,
      'tags': ['energy', 'solar', 'renewable', 'home'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Use Reusable Water Bottles',
      'description':
          'Carry a reusable water bottle instead of buying plastic bottles. This simple change can save hundreds of plastic bottles per year.',
      'category': 'Waste',
      'difficulty': 'Easy',
      'estimatedImpact': 5,
      'tags': ['waste', 'plastic', 'water', 'reusable'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Walk or Bike for Short Trips',
      'description':
          'Choose walking or biking for trips under 2 miles. It\'s good for your health and the environment.',
      'category': 'Transportation',
      'difficulty': 'Easy',
      'estimatedImpact': 10,
      'tags': ['transport', 'exercise', 'health', 'active'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Buy Local and Seasonal Food',
      'description':
          'Purchase locally grown, seasonal produce to reduce transportation emissions and support local farmers.',
      'category': 'Food',
      'difficulty': 'Easy',
      'estimatedImpact': 15,
      'tags': ['food', 'local', 'seasonal', 'farmers'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Reduce Water Usage',
      'description':
          'Take shorter showers, fix leaks, and use water-efficient appliances to conserve this precious resource.',
      'category': 'Water',
      'difficulty': 'Easy',
      'estimatedImpact': 8,
      'tags': ['water', 'conservation', 'home', 'efficiency'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Choose Eco-Friendly Accommodations',
      'description':
          'When traveling, stay at hotels and lodges that have eco-certifications and sustainable practices.',
      'category': 'Travel',
      'difficulty': 'Easy',
      'estimatedImpact': 30,
      'tags': ['travel', 'accommodation', 'eco-friendly', 'tourism'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Use Cloth Shopping Bags',
      'description':
          'Bring reusable cloth bags when shopping to reduce plastic bag waste and pollution.',
      'category': 'Shopping',
      'difficulty': 'Easy',
      'estimatedImpact': 3,
      'tags': ['shopping', 'plastic', 'reusable', 'waste'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'title': 'Insulate Your Home',
      'description':
          'Proper insulation reduces heating and cooling costs while lowering your carbon footprint.',
      'category': 'Home',
      'difficulty': 'Hard',
      'estimatedImpact': 50,
      'tags': ['home', 'energy', 'insulation', 'efficiency'],
      'imageUrl': '',
      'isVerified': true,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
  ];

  // Populate Firestore with sample tips
  static Future<void> populateSampleTips() async {
    try {
      // Check if tips already exist
      final existingTips = await _firestore
          .collection('sustainability_tips')
          .limit(1)
          .get();

      if (existingTips.docs.isNotEmpty) {
        print('Sustainability tips already exist in Firestore');
        return;
      }

      // Add sample tips to Firestore
      final batch = _firestore.batch();

      for (final tipData in _sampleTips) {
        final docRef = _firestore.collection('sustainability_tips').doc();
        batch.set(docRef, tipData);
      }

      await batch.commit();
      print('Successfully populated ${_sampleTips.length} sustainability tips');
    } catch (e) {
      print('Error populating sustainability tips: $e');
      throw Exception('Failed to populate sustainability tips: $e');
    }
  }

  // Add a single tip
  static Future<void> addTip(SustainabilityTip tip) async {
    try {
      await _firestore.collection('sustainability_tips').add(tip.toFirestore());
    } catch (e) {
      throw Exception('Failed to add tip: $e');
    }
  }

  // Get all tips
  static Future<List<SustainabilityTip>> getAllTips() async {
    try {
      final snapshot = await _firestore
          .collection('sustainability_tips')
          .where('isVerified', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SustainabilityTip.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tips: $e');
    }
  }

  // Clear all tips (for testing)
  static Future<void> clearAllTips() async {
    try {
      final snapshot = await _firestore.collection('sustainability_tips').get();
      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('Successfully cleared all sustainability tips');
    } catch (e) {
      print('Error clearing sustainability tips: $e');
      throw Exception('Failed to clear sustainability tips: $e');
    }
  }
}
