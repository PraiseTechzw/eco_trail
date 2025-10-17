import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, cancelled, completed, refunded }

enum PaymentStatus { pending, paid, failed, refunded }

class Booking {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String eventId;
  final String eventTitle;
  final String eventType; // 'event' or 'location'
  final DateTime eventDate;
  final String eventLocation;
  final int numberOfGuests;
  final double totalAmount;
  final String currency;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentIntentId;
  final String? paymentMethodId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  final String? notes;
  final String? cancellationReason;
  final DateTime? cancelledAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.eventId,
    required this.eventTitle,
    required this.eventType,
    required this.eventDate,
    required this.eventLocation,
    required this.numberOfGuests,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    this.paymentIntentId,
    this.paymentMethodId,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
    this.notes,
    this.cancellationReason,
    this.cancelledAt,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhone: data['userPhone'] ?? '',
      eventId: data['eventId'] ?? '',
      eventTitle: data['eventTitle'] ?? '',
      eventType: data['eventType'] ?? 'event',
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      eventLocation: data['eventLocation'] ?? '',
      numberOfGuests: data['numberOfGuests'] ?? 1,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      status: BookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == data['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentIntentId: data['paymentIntentId'],
      paymentMethodId: data['paymentMethodId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      metadata: data['metadata'],
      notes: data['notes'],
      cancellationReason: data['cancellationReason'],
      cancelledAt: data['cancelledAt'] != null
          ? (data['cancelledAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'eventType': eventType,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventLocation': eventLocation,
      'numberOfGuests': numberOfGuests,
      'totalAmount': totalAmount,
      'currency': currency,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'paymentIntentId': paymentIntentId,
      'paymentMethodId': paymentMethodId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata,
      'notes': notes,
      'cancellationReason': cancellationReason,
      'cancelledAt': cancelledAt != null
          ? Timestamp.fromDate(cancelledAt!)
          : null,
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? eventId,
    String? eventTitle,
    String? eventType,
    DateTime? eventDate,
    String? eventLocation,
    int? numberOfGuests,
    double? totalAmount,
    String? currency,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentIntentId,
    String? paymentMethodId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    String? notes,
    String? cancellationReason,
    DateTime? cancelledAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }
}
