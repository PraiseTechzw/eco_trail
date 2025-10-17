import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences preferences;
  final CarbonFootprint carbonFootprint;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
    required this.carbonFootprint,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      preferences: UserPreferences.fromMap(data['preferences'] ?? {}),
      carbonFootprint: CarbonFootprint.fromMap(data['carbonFootprint'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'preferences': preferences.toMap(),
      'carbonFootprint': carbonFootprint.toMap(),
    };
  }
}

class UserPreferences {
  final String language;
  final bool darkMode;
  final bool notificationsEnabled;
  final List<String> interests;
  final String preferredTransport;

  UserPreferences({
    this.language = 'en',
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.interests = const [],
    this.preferredTransport = 'public',
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      language: map['language'] ?? 'en',
      darkMode: map['darkMode'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      interests: List<String>.from(map['interests'] ?? []),
      preferredTransport: map['preferredTransport'] ?? 'public',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'interests': interests,
      'preferredTransport': preferredTransport,
    };
  }
}

class CarbonFootprint {
  final double totalEmissions; // in kg CO2
  final List<CarbonActivity> activities;
  final DateTime lastUpdated;

  CarbonFootprint({
    this.totalEmissions = 0.0,
    this.activities = const [],
    required this.lastUpdated,
  });

  factory CarbonFootprint.fromMap(Map<String, dynamic> map) {
    return CarbonFootprint(
      totalEmissions: (map['totalEmissions'] ?? 0.0).toDouble(),
      activities: (map['activities'] as List<dynamic>? ?? [])
          .map((activity) => CarbonActivity.fromMap(activity))
          .toList(),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalEmissions': totalEmissions,
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}

class CarbonActivity {
  final String type; // 'transport', 'accommodation', 'food'
  final double emissions; // in kg CO2
  final String description;
  final DateTime date;

  CarbonActivity({
    required this.type,
    required this.emissions,
    required this.description,
    required this.date,
  });

  factory CarbonActivity.fromMap(Map<String, dynamic> map) {
    return CarbonActivity(
      type: map['type'] ?? '',
      emissions: (map['emissions'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'emissions': emissions,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }
}
