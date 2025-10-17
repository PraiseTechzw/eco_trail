import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/booking_model.dart';
import '../../../../core/services/firebase_service.dart';

class BookingService {
  static const String _collection = 'bookings';

  // Create a new booking
  static Future<Booking> createBooking({
    required String eventId,
    required String eventTitle,
    required String eventType,
    required DateTime eventDate,
    required String eventLocation,
    required int numberOfGuests,
    required double totalAmount,
    required String currency,
    String? notes,
    Map<String, dynamic>? metadata,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to create a booking');
    }

    final now = DateTime.now();
    final booking = Booking(
      id: '', // Will be set by Firestore
      userId: user.uid,
      userName: user.displayName ?? 'Unknown User',
      userEmail: user.email ?? '',
      userPhone: user.phoneNumber ?? '',
      eventId: eventId,
      eventTitle: eventTitle,
      eventType: eventType,
      eventDate: eventDate,
      eventLocation: eventLocation,
      numberOfGuests: numberOfGuests,
      totalAmount: totalAmount,
      currency: currency,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.pending,
      createdAt: now,
      updatedAt: now,
      notes: notes,
      metadata: metadata,
    );

    final docRef = await FirebaseService.firestore
        .collection(_collection)
        .add(booking.toFirestore());

    return booking.copyWith(id: docRef.id);
  }

  // Get booking by ID
  static Future<Booking?> getBooking(String bookingId) async {
    try {
      final doc = await FirebaseService.firestore
          .collection(_collection)
          .doc(bookingId)
          .get();

      if (doc.exists) {
        return Booking.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  // Get user's bookings
  static Stream<List<Booking>> getUserBookings(String userId) {
    return FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Booking.fromFirestore(doc))
              .toList();
        });
  }

  // Get bookings by status
  static Stream<List<Booking>> getBookingsByStatus(
    String userId,
    BookingStatus status,
  ) {
    return FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Booking.fromFirestore(doc))
              .toList();
        });
  }

  // Update booking status
  static Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? cancellationReason,
  }) async {
    final updateData = <String, dynamic>{
      'status': status.name,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (status == BookingStatus.cancelled && cancellationReason != null) {
      updateData['cancellationReason'] = cancellationReason;
      updateData['cancelledAt'] = Timestamp.fromDate(DateTime.now());
    }

    await FirebaseService.firestore
        .collection(_collection)
        .doc(bookingId)
        .update(updateData);
  }

  // Update payment status
  static Future<void> updatePaymentStatus(
    String bookingId,
    PaymentStatus paymentStatus, {
    String? paymentIntentId,
    String? paymentMethodId,
  }) async {
    final updateData = <String, dynamic>{
      'paymentStatus': paymentStatus.name,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (paymentIntentId != null) {
      updateData['paymentIntentId'] = paymentIntentId;
    }

    if (paymentMethodId != null) {
      updateData['paymentMethodId'] = paymentMethodId;
    }

    // If payment is successful, confirm the booking
    if (paymentStatus == PaymentStatus.paid) {
      updateData['status'] = BookingStatus.confirmed.name;
    }

    await FirebaseService.firestore
        .collection(_collection)
        .doc(bookingId)
        .update(updateData);
  }

  // Cancel booking
  static Future<void> cancelBooking(String bookingId, String reason) async {
    await updateBookingStatus(
      bookingId,
      BookingStatus.cancelled,
      cancellationReason: reason,
    );
  }

  // Complete booking
  static Future<void> completeBooking(String bookingId) async {
    await updateBookingStatus(bookingId, BookingStatus.completed);
  }

  // Get booking statistics for user
  static Future<Map<String, int>> getBookingStats(String userId) async {
    final snapshot = await FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    final stats = <String, int>{
      'total': 0,
      'pending': 0,
      'confirmed': 0,
      'cancelled': 0,
      'completed': 0,
    };

    for (final doc in snapshot.docs) {
      final booking = Booking.fromFirestore(doc);
      stats['total'] = (stats['total'] ?? 0) + 1;
      stats[booking.status.name] = (stats[booking.status.name] ?? 0) + 1;
    }

    return stats;
  }

  // Check if user can book an event
  static Future<bool> canBookEvent(
    String userId,
    String eventId,
    DateTime eventDate,
  ) async {
    // Check if user already has a booking for this event
    final existingBookings = await FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .where(
          'status',
          whereIn: [BookingStatus.pending.name, BookingStatus.confirmed.name],
        )
        .get();

    return existingBookings.docs.isEmpty;
  }

  // Get upcoming bookings
  static Stream<List<Booking>> getUpcomingBookings(String userId) {
    final now = DateTime.now();
    return FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('eventDate', isGreaterThan: Timestamp.fromDate(now))
        .where(
          'status',
          whereIn: [BookingStatus.pending.name, BookingStatus.confirmed.name],
        )
        .orderBy('eventDate')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Booking.fromFirestore(doc))
              .toList();
        });
  }

  // Get past bookings
  static Stream<List<Booking>> getPastBookings(String userId) {
    final now = DateTime.now();
    return FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('eventDate', isLessThan: Timestamp.fromDate(now))
        .orderBy('eventDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Booking.fromFirestore(doc))
              .toList();
        });
  }
}
