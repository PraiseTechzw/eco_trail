import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../../../../core/services/firebase_service.dart';

class DemoEventsService {
  static Future<void> populateSampleEvents() async {
    try {
      final events = [
        Event(
          id: '',
          title: 'Sustainable Living Workshop',
          description:
              'Learn practical tips for reducing your environmental impact in daily life. This workshop covers energy conservation, waste reduction, and sustainable consumption habits.',
          category: 'Workshop',
          startDate: DateTime.now().add(const Duration(days: 7)),
          endDate: DateTime.now().add(const Duration(days: 7, hours: 3)),
          location: 'Green Community Center',
          address: '123 Eco Street, Green City',
          latitude: 37.7749,
          longitude: -122.4194,
          organizer: 'Green Living Foundation',
          organizerEmail: 'info@greenliving.org',
          organizerPhone: '+1-555-0123',
          price: 25.0,
          currency: 'USD',
          maxParticipants: 30,
          currentParticipants: 15,
          tags: ['sustainability', 'workshop', 'education'],
          requirements: ['Bring notebook', 'Water bottle'],
          imageUrl: 'https://example.com/workshop.jpg',
          isVerified: true,
          status: EventStatus.upcoming,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Event(
          id: '',
          title: 'Nature Photography Walk',
          description:
              'Join us for a guided photography walk through the local nature reserve. Learn to capture the beauty of nature while respecting the environment.',
          category: 'Outdoor Activity',
          startDate: DateTime.now().add(const Duration(days: 14)),
          endDate: DateTime.now().add(const Duration(days: 14, hours: 4)),
          location: 'Riverside Nature Reserve',
          address: '456 Nature Trail, Riverside',
          latitude: 37.7849,
          longitude: -122.4094,
          organizer: 'Nature Photography Club',
          organizerEmail: 'contact@naturephoto.org',
          organizerPhone: '+1-555-0456',
          price: 15.0,
          currency: 'USD',
          maxParticipants: 20,
          currentParticipants: 8,
          tags: ['photography', 'nature', 'outdoor'],
          requirements: ['Camera or smartphone', 'Comfortable walking shoes'],
          imageUrl: 'https://example.com/photography.jpg',
          isVerified: true,
          status: EventStatus.upcoming,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Event(
          id: '',
          title: 'Zero Waste Cooking Class',
          description:
              'Learn to cook delicious meals while minimizing food waste. Discover creative recipes using vegetable scraps and sustainable cooking techniques.',
          category: 'Cooking Class',
          startDate: DateTime.now().add(const Duration(days: 21)),
          endDate: DateTime.now().add(const Duration(days: 21, hours: 2)),
          location: 'Sustainable Kitchen Studio',
          address: '789 Green Avenue, Eco Town',
          latitude: 37.7949,
          longitude: -122.3994,
          organizer: 'Eco Chef Academy',
          organizerEmail: 'chef@ecocooking.org',
          organizerPhone: '+1-555-0789',
          price: 35.0,
          currency: 'USD',
          maxParticipants: 12,
          currentParticipants: 12,
          tags: ['cooking', 'zero waste', 'sustainable'],
          requirements: ['Apron', 'Container for leftovers'],
          imageUrl: 'https://example.com/cooking.jpg',
          isVerified: true,
          status: EventStatus.upcoming,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Event(
          id: '',
          title: 'Community Garden Volunteer Day',
          description:
              'Join our community garden maintenance day. Help plant, water, and maintain our shared green space while learning about urban gardening.',
          category: 'Volunteer',
          startDate: DateTime.now().add(const Duration(days: 3)),
          endDate: DateTime.now().add(const Duration(days: 3, hours: 6)),
          location: 'Community Garden',
          address: '321 Garden Street, Community City',
          latitude: 37.7649,
          longitude: -122.4294,
          organizer: 'Green Thumb Community',
          organizerEmail: 'volunteer@greenthumb.org',
          organizerPhone: '+1-555-0321',
          price: 0.0,
          currency: 'USD',
          maxParticipants: 25,
          currentParticipants: 18,
          tags: ['volunteer', 'gardening', 'community'],
          requirements: ['Work gloves', 'Water bottle', 'Sun hat'],
          imageUrl: 'https://example.com/garden.jpg',
          isVerified: true,
          status: EventStatus.upcoming,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Event(
          id: '',
          title: 'Renewable Energy Tour',
          description:
              'Visit local solar and wind energy installations. Learn about renewable energy technologies and their environmental benefits.',
          category: 'Educational Tour',
          startDate: DateTime.now().add(const Duration(days: 28)),
          endDate: DateTime.now().add(const Duration(days: 28, hours: 5)),
          location: 'Renewable Energy Center',
          address: '654 Solar Drive, Energy City',
          latitude: 37.7549,
          longitude: -122.4394,
          organizer: 'Clean Energy Society',
          organizerEmail: 'tours@cleanenergy.org',
          organizerPhone: '+1-555-0654',
          price: 20.0,
          currency: 'USD',
          maxParticipants: 15,
          currentParticipants: 7,
          tags: ['renewable energy', 'tour', 'education'],
          requirements: ['Comfortable shoes', 'Notebook'],
          imageUrl: 'https://example.com/energy.jpg',
          isVerified: true,
          status: EventStatus.upcoming,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      for (final event in events) {
        await FirebaseService.firestore
            .collection('events')
            .add(event.toFirestore());
      }

      print('Sample events populated successfully');
    } catch (e) {
      print('Error populating sample events: $e');
    }
  }
}
