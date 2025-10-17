import 'package:cloud_firestore/cloud_firestore.dart';

class EcoLocation {
  final String id;
  final String name;
  final String description;
  final String type; // 'Eco Lodge', 'Nature Trail', 'Cultural Site', etc.
  final GeoPoint coordinates;
  final String address;
  final List<String> images;
  final String ecoCertification; // 'Bronze', 'Silver', 'Gold', 'Platinum'
  final List<String> sustainabilityFeatures;
  final double rating;
  final int reviewCount;
  final String contactInfo;
  final String website;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  EcoLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.coordinates,
    required this.address,
    this.images = const [],
    this.ecoCertification = 'Bronze',
    this.sustainabilityFeatures = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.contactInfo = '',
    this.website = '',
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EcoLocation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EcoLocation(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      coordinates: data['coordinates'] as GeoPoint,
      address: data['address'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      ecoCertification: data['ecoCertification'] ?? 'Bronze',
      sustainabilityFeatures: List<String>.from(
        data['sustainabilityFeatures'] ?? [],
      ),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      contactInfo: data['contactInfo'] ?? '',
      website: data['website'] ?? '',
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'coordinates': coordinates,
      'address': address,
      'images': images,
      'ecoCertification': ecoCertification,
      'sustainabilityFeatures': sustainabilityFeatures,
      'rating': rating,
      'reviewCount': reviewCount,
      'contactInfo': contactInfo,
      'website': website,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final String category; // 'Workshop', 'Festival', 'Tour', etc.
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final GeoPoint? coordinates;
  final String organizer;
  final String contactInfo;
  final List<String> images;
  final double price;
  final String currency;
  final int maxParticipants;
  final int currentParticipants;
  final bool isOnline;
  final String? meetingLink;
  final List<String> tags;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.coordinates,
    required this.organizer,
    this.contactInfo = '',
    this.images = const [],
    this.price = 0.0,
    this.currency = 'USD',
    this.maxParticipants = 0,
    this.currentParticipants = 0,
    this.isOnline = false,
    this.meetingLink,
    this.tags = const [],
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      coordinates: data['coordinates'] as GeoPoint?,
      organizer: data['organizer'] ?? '',
      contactInfo: data['contactInfo'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      price: (data['price'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      maxParticipants: data['maxParticipants'] ?? 0,
      currentParticipants: data['currentParticipants'] ?? 0,
      isOnline: data['isOnline'] ?? false,
      meetingLink: data['meetingLink'],
      tags: List<String>.from(data['tags'] ?? []),
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'coordinates': coordinates,
      'organizer': organizer,
      'contactInfo': contactInfo,
      'images': images,
      'price': price,
      'currency': currency,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
      'tags': tags,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
