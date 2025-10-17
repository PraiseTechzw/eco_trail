import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/eco_location_model.dart';
import '../../../../core/services/firebase_service.dart';

class DemoLocationsService {
  static Future<void> populateSampleLocations() async {
    try {
      final locations = [
        EcoLocation(
          id: '',
          name: 'Green Valley Eco Lodge',
          description:
              'A sustainable mountain retreat offering eco-friendly accommodations with solar power, organic gardens, and nature trails.',
          type: 'Eco Lodge',
          coordinates: const LatLng(37.7749, -122.4194),
          address: '123 Mountain View Road',
          city: 'Green Valley',
          country: 'USA',
          phone: '+1-555-0100',
          email: 'info@greenvalleylodge.com',
          website: 'https://greenvalleylodge.com',
          images: [
            'https://example.com/lodge1.jpg',
            'https://example.com/lodge2.jpg',
          ],
          sustainabilityFeatures: [
            'Solar Power',
            'Rainwater Harvesting',
            'Organic Garden',
            'Composting System',
            'LED Lighting',
          ],
          ecoCertification: 'Green Key Certified',
          rating: 4.8,
          reviewCount: 127,
          priceRange: 150.0,
          currency: 'USD',
          amenities: [
            'WiFi',
            'Restaurant',
            'Spa',
            'Hiking Trails',
            'Bike Rental',
          ],
          operatingHours: {
            'Monday': '24/7',
            'Tuesday': '24/7',
            'Wednesday': '24/7',
            'Thursday': '24/7',
            'Friday': '24/7',
            'Saturday': '24/7',
            'Sunday': '24/7',
          },
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        EcoLocation(
          id: '',
          name: 'Riverside Nature Trail',
          description:
              'A 5-mile scenic trail along the river featuring diverse wildlife, native plants, and educational signage about local ecosystems.',
          type: 'Nature Trail',
          coordinates: const LatLng(37.7849, -122.4094),
          address: '456 River Road',
          city: 'Riverside',
          country: 'USA',
          phone: '+1-555-0200',
          email: 'trails@riversidepark.org',
          website: 'https://riversidepark.org',
          images: [
            'https://example.com/trail1.jpg',
            'https://example.com/trail2.jpg',
          ],
          sustainabilityFeatures: [
            'Native Plant Restoration',
            'Wildlife Conservation',
            'Educational Programs',
            'Waste Reduction',
            'Carbon Neutral Operations',
          ],
          ecoCertification: 'National Park Service',
          rating: 4.6,
          reviewCount: 89,
          priceRange: 0.0,
          currency: 'USD',
          amenities: [
            'Parking',
            'Restrooms',
            'Picnic Areas',
            'Visitor Center',
            'Guided Tours',
          ],
          operatingHours: {
            'Monday': '6:00 AM - 8:00 PM',
            'Tuesday': '6:00 AM - 8:00 PM',
            'Wednesday': '6:00 AM - 8:00 PM',
            'Thursday': '6:00 AM - 8:00 PM',
            'Friday': '6:00 AM - 8:00 PM',
            'Saturday': '6:00 AM - 8:00 PM',
            'Sunday': '6:00 AM - 8:00 PM',
          },
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        EcoLocation(
          id: '',
          name: 'Heritage Cultural Center',
          description:
              'A cultural center dedicated to preserving local traditions and promoting sustainable cultural practices through exhibitions and workshops.',
          type: 'Cultural Site',
          coordinates: const LatLng(37.7949, -122.3994),
          address: '789 Heritage Street',
          city: 'Cultural City',
          country: 'USA',
          phone: '+1-555-0300',
          email: 'info@heritagecenter.org',
          website: 'https://heritagecenter.org',
          images: [
            'https://example.com/cultural1.jpg',
            'https://example.com/cultural2.jpg',
          ],
          sustainabilityFeatures: [
            'Energy Efficient Building',
            'Recycled Materials',
            'Local Artisan Support',
            'Cultural Preservation',
            'Community Programs',
          ],
          ecoCertification: 'LEED Gold',
          rating: 4.7,
          reviewCount: 156,
          priceRange: 12.0,
          currency: 'USD',
          amenities: ['Museum', 'Gift Shop', 'Café', 'Event Space', 'Parking'],
          operatingHours: {
            'Monday': 'Closed',
            'Tuesday': '10:00 AM - 6:00 PM',
            'Wednesday': '10:00 AM - 6:00 PM',
            'Thursday': '10:00 AM - 6:00 PM',
            'Friday': '10:00 AM - 8:00 PM',
            'Saturday': '10:00 AM - 6:00 PM',
            'Sunday': '12:00 PM - 5:00 PM',
          },
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        EcoLocation(
          id: '',
          name: 'Sunrise Organic Farm',
          description:
              'A certified organic farm offering farm-to-table experiences, educational tours, and fresh produce sales with sustainable farming practices.',
          type: 'Local Farm',
          coordinates: const LatLng(37.7649, -122.4294),
          address: '321 Farm Road',
          city: 'Farm Valley',
          country: 'USA',
          phone: '+1-555-0400',
          email: 'hello@sunrisefarm.com',
          website: 'https://sunrisefarm.com',
          images: [
            'https://example.com/farm1.jpg',
            'https://example.com/farm2.jpg',
          ],
          sustainabilityFeatures: [
            'Organic Certification',
            'Composting',
            'Crop Rotation',
            'Water Conservation',
            'Biodiversity Protection',
          ],
          ecoCertification: 'USDA Organic',
          rating: 4.9,
          reviewCount: 203,
          priceRange: 8.0,
          currency: 'USD',
          amenities: [
            'Farm Stand',
            'Tours',
            'Workshops',
            'CSA Program',
            'Picnic Area',
          ],
          operatingHours: {
            'Monday': '8:00 AM - 5:00 PM',
            'Tuesday': '8:00 AM - 5:00 PM',
            'Wednesday': '8:00 AM - 5:00 PM',
            'Thursday': '8:00 AM - 5:00 PM',
            'Friday': '8:00 AM - 5:00 PM',
            'Saturday': '8:00 AM - 6:00 PM',
            'Sunday': '9:00 AM - 4:00 PM',
          },
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        EcoLocation(
          id: '',
          name: 'Eco Bistro Restaurant',
          description:
              'A farm-to-table restaurant serving locally sourced, organic meals with zero-waste practices and sustainable seafood options.',
          type: 'Sustainable Restaurant',
          coordinates: const LatLng(37.7549, -122.4394),
          address: '654 Green Street',
          city: 'Eco City',
          country: 'USA',
          phone: '+1-555-0500',
          email: 'reservations@ecobistro.com',
          website: 'https://ecobistro.com',
          images: [
            'https://example.com/restaurant1.jpg',
            'https://example.com/restaurant2.jpg',
          ],
          sustainabilityFeatures: [
            'Local Sourcing',
            'Zero Waste Kitchen',
            'Compostable Packaging',
            'Energy Efficient Appliances',
            'Sustainable Seafood',
          ],
          ecoCertification: 'Green Restaurant Association',
          rating: 4.5,
          reviewCount: 178,
          priceRange: 45.0,
          currency: 'USD',
          amenities: [
            'Full Bar',
            'Outdoor Seating',
            'Private Dining',
            'Takeout',
            'Delivery',
          ],
          operatingHours: {
            'Monday': 'Closed',
            'Tuesday': '5:00 PM - 10:00 PM',
            'Wednesday': '5:00 PM - 10:00 PM',
            'Thursday': '5:00 PM - 10:00 PM',
            'Friday': '5:00 PM - 11:00 PM',
            'Saturday': '4:00 PM - 11:00 PM',
            'Sunday': '4:00 PM - 9:00 PM',
          },
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      for (final location in locations) {
        await FirebaseService.firestore
            .collection('eco_locations')
            .add(location.toFirestore());
      }

      print('Sample eco locations populated successfully');
    } catch (e) {
      print('Error populating sample locations: $e');
    }
  }
}
