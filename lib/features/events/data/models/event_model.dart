import 'package:cloud_firestore/cloud_firestore.dart';

enum EventStatus {
  upcoming,
  ongoing,
  ended,
  cancelled,
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
  final EventStatus status;
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
    required this.status,
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
      status: EventStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => EventStatus.upcoming,
      ),
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
      'status': status.name,
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
    EventStatus? status,
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
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isAvailable => currentParticipants < maxParticipants;
  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isOngoing => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isEnded => DateTime.now().isAfter(endDate);
}
