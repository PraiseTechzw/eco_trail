import 'package:cloud_firestore/cloud_firestore.dart';

class SustainabilityTip {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final int estimatedImpact; // CO2 saved in kg per month
  final List<String> tags;
  final String imageUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  SustainabilityTip({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty = 'Easy',
    this.estimatedImpact = 0,
    this.tags = const [],
    this.imageUrl = '',
    this.isVerified = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SustainabilityTip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SustainabilityTip(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? 'Easy',
      estimatedImpact: data['estimatedImpact'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      isVerified: data['isVerified'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'estimatedImpact': estimatedImpact,
      'tags': tags,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class CarbonActivity {
  final String id;
  final String userId;
  final String type; // 'transport', 'energy', 'food', 'waste'
  final String description;
  final double emissions; // in kg CO2
  final DateTime date;
  final Map<String, dynamic>
  metadata; // Additional data like distance, fuel type, etc.

  CarbonActivity({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.emissions,
    required this.date,
    this.metadata = const {},
  });

  factory CarbonActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarbonActivity(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      emissions: (data['emissions'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'emissions': emissions,
      'date': Timestamp.fromDate(date),
      'metadata': metadata,
    };
  }
}

class CarbonFootprintSummary {
  final double totalEmissions;
  final double monthlyEmissions;
  final double weeklyEmissions;
  final double dailyEmissions;
  final Map<String, double> emissionsByCategory;
  final List<CarbonActivity> recentActivities;
  final DateTime lastUpdated;

  CarbonFootprintSummary({
    required this.totalEmissions,
    required this.monthlyEmissions,
    required this.weeklyEmissions,
    required this.dailyEmissions,
    required this.emissionsByCategory,
    required this.recentActivities,
    required this.lastUpdated,
  });

  factory CarbonFootprintSummary.fromMap(Map<String, dynamic> map) {
    return CarbonFootprintSummary(
      totalEmissions: (map['totalEmissions'] ?? 0.0).toDouble(),
      monthlyEmissions: (map['monthlyEmissions'] ?? 0.0).toDouble(),
      weeklyEmissions: (map['weeklyEmissions'] ?? 0.0).toDouble(),
      dailyEmissions: (map['dailyEmissions'] ?? 0.0).toDouble(),
      emissionsByCategory: Map<String, double>.from(
        map['emissionsByCategory'] ?? {},
      ),
      recentActivities: (map['recentActivities'] as List<dynamic>? ?? [])
          .map((activity) => CarbonActivity.fromFirestore(activity))
          .toList(),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalEmissions': totalEmissions,
      'monthlyEmissions': monthlyEmissions,
      'weeklyEmissions': weeklyEmissions,
      'dailyEmissions': dailyEmissions,
      'emissionsByCategory': emissionsByCategory,
      'recentActivities': recentActivities
          .map((activity) => activity.toFirestore())
          .toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
