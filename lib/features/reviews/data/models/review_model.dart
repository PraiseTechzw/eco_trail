import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String locationId;
  final String locationName;
  final String locationType;
  final double rating;
  final String title;
  final String content;
  final List<String> images;
  final List<String> tags;
  final bool isVerified;
  final bool isHelpful;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.rating,
    required this.title,
    required this.content,
    this.images = const [],
    this.tags = const [],
    this.isVerified = false,
    this.isHelpful = false,
    this.helpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      locationId: data['locationId'] ?? '',
      locationName: data['locationName'] ?? '',
      locationType: data['locationType'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      isVerified: data['isVerified'] ?? false,
      isHelpful: data['isHelpful'] ?? false,
      helpfulCount: data['helpfulCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'locationId': locationId,
      'locationName': locationName,
      'locationType': locationType,
      'rating': rating,
      'title': title,
      'content': content,
      'images': images,
      'tags': tags,
      'isVerified': isVerified,
      'isHelpful': isHelpful,
      'helpfulCount': helpfulCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? locationId,
    String? locationName,
    String? locationType,
    double? rating,
    String? title,
    String? content,
    List<String>? images,
    List<String>? tags,
    bool? isVerified,
    bool? isHelpful,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      locationType: locationType ?? this.locationType,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      isVerified: isVerified ?? this.isVerified,
      isHelpful: isHelpful ?? this.isHelpful,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ReviewSummary {
  final String locationId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count
  final List<String> commonTags;
  final DateTime lastUpdated;

  ReviewSummary({
    required this.locationId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.commonTags,
    required this.lastUpdated,
  });

  factory ReviewSummary.fromMap(Map<String, dynamic> map) {
    return ReviewSummary(
      locationId: map['locationId'] ?? '',
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      ratingDistribution: Map<int, int>.from(map['ratingDistribution'] ?? {}),
      commonTags: List<String>.from(map['commonTags'] ?? []),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'ratingDistribution': ratingDistribution,
      'commonTags': commonTags,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}

class Recommendation {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final List<String> images;
  final double rating;
  final int helpfulCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recommendation({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    this.tags = const [],
    this.images = const [],
    this.rating = 0.0,
    this.helpfulCount = 0,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recommendation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recommendation(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      helpfulCount: data['helpfulCount'] ?? 0,
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'tags': tags,
      'images': images,
      'rating': rating,
      'helpfulCount': helpfulCount,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
