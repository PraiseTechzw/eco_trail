import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/eco_location_model.dart';

class DemoDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> populateDemoData() async {
    // Add sample eco locations
    await _addSampleEcoLocations();
    // Add sample events
    await _addSampleEvents();
  }

  static Future<void> _addSampleEcoLocations() async {
    final locations = [
      {
        'name': 'Green Valley Eco Lodge',
        'description':
            'A sustainable mountain retreat with solar power and organic gardens.',
        'type': 'Eco Lodge',
        'coordinates': const GeoPoint(37.7749, -122.4194), // San Francisco
        'address': '123 Green Valley Road, San Francisco, CA',
        'images': ['https://example.com/lodge1.jpg'],
        'ecoCertification': 'Gold',
        'sustainabilityFeatures': [
          'Solar Power',
          'Rainwater Harvesting',
          'Organic Garden',
          'Composting System',
        ],
        'rating': 4.8,
        'reviewCount': 127,
        'phone': '+1-555-0123',
        'website': 'https://greenvalleylodge.com',
        'isVerified': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'name': 'Ocean Breeze Sustainable Resort',
        'description':
            'Beachfront eco-resort with wind energy and marine conservation programs.',
        'type': 'Eco Lodge',
        'coordinates': const GeoPoint(34.0522, -118.2437), // Los Angeles
        'address': '456 Ocean Drive, Los Angeles, CA',
        'images': ['https://example.com/resort1.jpg'],
        'ecoCertification': 'Platinum',
        'sustainabilityFeatures': [
          'Wind Energy',
          'Marine Conservation',
          'Zero Waste',
          'Local Sourcing',
        ],
        'rating': 4.9,
        'reviewCount': 203,
        'phone': '+1-555-0456',
        'website': 'https://oceanbreezeresort.com',
        'isVerified': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'name': 'Mountain Trail Nature Reserve',
        'description':
            'Protected wilderness area with guided eco-tours and wildlife observation.',
        'type': 'Nature Trail',
        'coordinates': const GeoPoint(40.7128, -74.0060), // New York
        'address': '789 Mountain View Trail, New York, NY',
        'images': ['https://example.com/trail1.jpg'],
        'ecoCertification': 'Gold',
        'sustainabilityFeatures': [
          'Wildlife Protection',
          'Educational Programs',
          'Sustainable Tourism',
          'Local Community Support',
        ],
        'rating': 4.7,
        'reviewCount': 89,
        'contactInfo': '+1-555-0789',
        'website': 'https://mountaintrail.org',
        'isVerified': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    for (var location in locations) {
      await _firestore.collection('eco_locations').add(location);
    }
  }

  static Future<void> _addSampleEvents() async {
    final events = [
      {
        'title': 'Sustainable Living Workshop',
        'description':
            'Learn practical tips for reducing your carbon footprint and living more sustainably.',
        'category': 'Workshop',
        'startDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7)),
        ),
        'endDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7, hours: 3)),
        ),
        'location': 'Green Community Center, San Francisco',
        'coordinates': const GeoPoint(37.7749, -122.4194),
        'organizer': 'Eco Warriors Foundation',
        'contactInfo': 'info@ecowarriors.org',
        'images': ['https://example.com/workshop1.jpg'],
        'price': 25.0,
        'currency': 'USD',
        'maxParticipants': 50,
        'currentParticipants': 23,
        'isOnline': false,
        'tags': ['Sustainability', 'Education', 'Community'],
        'isVerified': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Earth Day Festival 2024',
        'description':
            'Celebrate Earth Day with local vendors, workshops, and environmental activities.',
        'category': 'Festival',
        'startDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 14)),
        ),
        'endDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 14, hours: 8)),
        ),
        'location': 'Central Park, New York',
        'coordinates': const GeoPoint(40.7829, -73.9654),
        'organizer': 'Green Earth Alliance',
        'contactInfo': 'festival@greenearth.org',
        'images': ['https://example.com/festival1.jpg'],
        'price': 0.0,
        'currency': 'USD',
        'maxParticipants': 1000,
        'currentParticipants': 456,
        'isOnline': false,
        'tags': ['Festival', 'Earth Day', 'Community', 'Free'],
        'isVerified': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Virtual Climate Action Summit',
        'description':
            'Join global leaders and activists in discussing climate solutions and action plans.',
        'category': 'Conference',
        'startDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 21)),
        ),
        'endDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 21, hours: 6)),
        ),
        'location': 'Online Event',
        'coordinates': null,
        'organizer': 'Climate Action Network',
        'contactInfo': 'summit@climateaction.org',
        'images': ['https://example.com/summit1.jpg'],
        'price': 0.0,
        'currency': 'USD',
        'maxParticipants': 5000,
        'currentParticipants': 1234,
        'isOnline': true,
        'meetingLink': 'https://zoom.us/j/123456789',
        'tags': ['Climate', 'Virtual', 'Global', 'Free'],
        'isVerified': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    for (var event in events) {
      await _firestore.collection('events').add(event);
    }
  }
}
