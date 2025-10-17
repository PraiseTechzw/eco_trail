import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EcoLocation {
  final String id;
  final String name;
  final String description;
  final String type;
  final LatLng coordinates;
  final String address;
  final String city;
  final String country;
  final String phone;
  final String email;
  final String website;
  final List<String> images;
  final List<String> sustainabilityFeatures;
  final String ecoCertification;
  final double rating;
  final int reviewCount;
  final double priceRange;
  final String currency;
  final List<String> amenities;
  final Map<String, String> operatingHours;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const EcoLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.coordinates,
    required this.address,
    required this.city,
    required this.country,
    required this.phone,
    required this.email,
    required this.website,
    required this.images,
    required this.sustainabilityFeatures,
    required this.ecoCertification,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.currency,
    required this.amenities,
    required this.operatingHours,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory EcoLocation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EcoLocation(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      coordinates: LatLng(
        (data['latitude'] ?? 0.0).toDouble(),
        (data['longitude'] ?? 0.0).toDouble(),
      ),
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      sustainabilityFeatures: List<String>.from(data['sustainabilityFeatures'] ?? []),
      ecoCertification: data['ecoCertification'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      priceRange: (data['priceRange'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      amenities: List<String>.from(data['amenities'] ?? []),
      operatingHours: Map<String, String>.from(data['operatingHours'] ?? {}),
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'address': address,
      'city': city,
      'country': country,
      'phone': phone,
      'email': email,
      'website': website,
      'images': images,
      'sustainabilityFeatures': sustainabilityFeatures,
      'ecoCertification': ecoCertification,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'currency': currency,
      'amenities': amenities,
      'operatingHours': operatingHours,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata,
    };
  }

  EcoLocation copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    LatLng? coordinates,
    String? address,
    String? city,
    String? country,
    String? phone,
    String? email,
    String? website,
    List<String>? images,
    List<String>? sustainabilityFeatures,
    String? ecoCertification,
    double? rating,
    int? reviewCount,
    double? priceRange,
    String? currency,
    List<String>? amenities,
    Map<String, String>? operatingHours,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return EcoLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      images: images ?? this.images,
      sustainabilityFeatures: sustainabilityFeatures ?? this.sustainabilityFeatures,
      ecoCertification: ecoCertification ?? this.ecoCertification,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      priceRange: priceRange ?? this.priceRange,
      currency: currency ?? this.currency,
      amenities: amenities ?? this.amenities,
      operatingHours: operatingHours ?? this.operatingHours,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final String organizer;
  final String organizerEmail;
  final String organizerPhone;
  final double price;
  final String currency;
  final int maxParticipants;
  final int currentParticipants;
  final List<String> tags;
  final List<String> requirements;
  final String imageUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.organizer,
    required this.organizerEmail,
    required this.organizerPhone,
    required this.price,
    required this.currency,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.tags,
    required this.requirements,
    required this.imageUrl,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
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
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      organizer: data['organizer'] ?? '',
      organizerEmail: data['organizerEmail'] ?? '',
      organizerPhone: data['organizerPhone'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      maxParticipants: data['maxParticipants'] ?? 0,
      currentParticipants: data['currentParticipants'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      requirements: List<String>.from(data['requirements'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      metadata: data['metadata'],
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
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'organizer': organizer,
      'organizerEmail': organizerEmail,
      'organizerPhone': organizerPhone,
      'price': price,
      'currency': currency,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'tags': tags,
      'requirements': requirements,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata,
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    String? address,
    double? latitude,
    double? longitude,
    String? organizer,
    String? organizerEmail,
    String? organizerPhone,
    double? price,
    String? currency,
    int? maxParticipants,
    int? currentParticipants,
    List<String>? tags,
    List<String>? requirements,
    String? imageUrl,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      organizer: organizer ?? this.organizer,
      organizerEmail: organizerEmail ?? this.organizerEmail,
      organizerPhone: organizerPhone ?? this.organizerPhone,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      tags: tags ?? this.tags,
      requirements: requirements ?? this.requirements,
      imageUrl: imageUrl ?? this.imageUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}