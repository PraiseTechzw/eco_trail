import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> carbonFootprint;
  final List<String> favoriteLocations;
  final List<String> favoriteEvents;
  final List<String> completedTips;
  final Map<String, dynamic> statistics;
  final bool isEmailVerified;
  final String? bio;
  final String? location;
  final List<String> interests;
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
    required this.carbonFootprint,
    required this.favoriteLocations,
    required this.favoriteEvents,
    required this.completedTips,
    required this.statistics,
    required this.isEmailVerified,
    this.bio,
    this.location,
    required this.interests,
    this.metadata,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
      carbonFootprint: Map<String, dynamic>.from(data['carbonFootprint'] ?? {}),
      favoriteLocations: List<String>.from(data['favoriteLocations'] ?? []),
      favoriteEvents: List<String>.from(data['favoriteEvents'] ?? []),
      completedTips: List<String>.from(data['completedTips'] ?? []),
      statistics: Map<String, dynamic>.from(data['statistics'] ?? {}),
      isEmailVerified: data['isEmailVerified'] ?? false,
      bio: data['bio'],
      location: data['location'],
      interests: List<String>.from(data['interests'] ?? []),
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'preferences': preferences,
      'carbonFootprint': carbonFootprint,
      'favoriteLocations': favoriteLocations,
      'favoriteEvents': favoriteEvents,
      'completedTips': completedTips,
      'statistics': statistics,
      'isEmailVerified': isEmailVerified,
      'bio': bio,
      'location': location,
      'interests': interests,
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? carbonFootprint,
    List<String>? favoriteLocations,
    List<String>? favoriteEvents,
    List<String>? completedTips,
    Map<String, dynamic>? statistics,
    bool? isEmailVerified,
    String? bio,
    String? location,
    List<String>? interests,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      carbonFootprint: carbonFootprint ?? this.carbonFootprint,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
      favoriteEvents: favoriteEvents ?? this.favoriteEvents,
      completedTips: completedTips ?? this.completedTips,
      statistics: statistics ?? this.statistics,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      metadata: metadata ?? this.metadata,
    );
  }
}