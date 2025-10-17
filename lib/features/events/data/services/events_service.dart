import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/eco_location_model.dart';

class EventsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all events
  static Stream<List<Event>> getEventsStream() {
    return _firestore
        .collection('events')
        .where('isVerified', isEqualTo: true)
        .orderBy('startDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList(),
        );
  }

  // Get upcoming events
  static Future<List<Event>> getUpcomingEvents() async {
    try {
      final now = Timestamp.now();
      final snapshot = await _firestore
          .collection('events')
          .where('isVerified', isEqualTo: true)
          .where('startDate', isGreaterThan: now)
          .orderBy('startDate')
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }

  // Get events by category
  static Future<List<Event>> getEventsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('isVerified', isEqualTo: true)
          .where('category', isEqualTo: category)
          .orderBy('startDate')
          .get();

      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch events by category: $e');
    }
  }

  // Get events by date range
  static Future<List<Event>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startTimestamp = Timestamp.fromDate(startDate);
      final endTimestamp = Timestamp.fromDate(endDate);

      final snapshot = await _firestore
          .collection('events')
          .where('isVerified', isEqualTo: true)
          .where('startDate', isGreaterThanOrEqualTo: startTimestamp)
          .where('startDate', isLessThanOrEqualTo: endTimestamp)
          .orderBy('startDate')
          .get();

      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch events by date range: $e');
    }
  }

  // Search events
  static Future<List<Event>> searchEvents(String query) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('isVerified', isEqualTo: true)
          .get();

      final allEvents = snapshot.docs
          .map((doc) => Event.fromFirestore(doc))
          .toList();

      if (query.isEmpty) return allEvents;

      return allEvents.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.description.toLowerCase().contains(query.toLowerCase()) ||
            event.category.toLowerCase().contains(query.toLowerCase()) ||
            event.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  // Get events for a specific month
  static Future<List<Event>> getEventsForMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return getEventsByDateRange(startOfMonth, endOfMonth);
  }

  // Book an event
  static Future<void> bookEvent(String eventId, String userId) async {
    try {
      // Check if event has available spots
      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) {
        throw Exception('Event not found');
      }

      final event = Event.fromFirestore(eventDoc);
      if (event.currentParticipants >= event.maxParticipants) {
        throw Exception('Event is fully booked');
      }

      // Add booking
      await _firestore.collection('bookings').add({
        'eventId': eventId,
        'userId': userId,
        'bookingDate': Timestamp.now(),
        'status': 'confirmed',
      });

      // Update participant count
      await _firestore.collection('events').doc(eventId).update({
        'currentParticipants': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to book event: $e');
    }
  }

  // Cancel booking
  static Future<void> cancelBooking(String bookingId, String eventId) async {
    try {
      // Delete booking
      await _firestore.collection('bookings').doc(bookingId).delete();

      // Update participant count
      await _firestore.collection('events').doc(eventId).update({
        'currentParticipants': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Get user's bookings
  static Stream<List<Map<String, dynamic>>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'confirmed')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList(),
        );
  }
}
