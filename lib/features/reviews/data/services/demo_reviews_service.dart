import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class DemoReviewsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample reviews data
  static final List<Map<String, dynamic>> _sampleReviews = [
    {
      'userId': 'user1',
      'userName': 'Sarah Johnson',
      'userAvatar': '',
      'locationId': 'location1',
      'locationName': 'Green Valley Eco Lodge',
      'locationType': 'eco lodge',
      'rating': 4.5,
      'title': 'Amazing sustainable experience!',
      'content':
          'This eco lodge exceeded all my expectations. The solar panels, rainwater harvesting, and organic garden made me feel good about my stay. The staff was incredibly knowledgeable about sustainability practices.',
      'images': [],
      'tags': ['sustainable', 'solar', 'organic', 'friendly staff'],
      'isVerified': true,
      'isHelpful': true,
      'helpfulCount': 12,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user2',
      'userName': 'Mike Chen',
      'userAvatar': '',
      'locationId': 'location2',
      'locationName': 'Mountain Trail Adventure',
      'locationType': 'nature trail',
      'rating': 4.8,
      'title': 'Perfect hiking experience',
      'content':
          'The trail was well-maintained and the views were breathtaking. The eco-friendly practices like composting toilets and solar-powered stations were impressive.',
      'images': [],
      'tags': ['hiking', 'views', 'eco-friendly', 'well-maintained'],
      'isVerified': true,
      'isHelpful': true,
      'helpfulCount': 8,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user3',
      'userName': 'Emma Rodriguez',
      'userAvatar': '',
      'locationId': 'location3',
      'locationName': 'Heritage Cultural Center',
      'locationType': 'cultural site',
      'rating': 4.2,
      'title': 'Rich cultural experience',
      'content':
          'The cultural center beautifully preserves local traditions while promoting sustainable tourism. The guided tours were informative and the gift shop supports local artisans.',
      'images': [],
      'tags': ['culture', 'heritage', 'local artisans', 'educational'],
      'isVerified': true,
      'isHelpful': false,
      'helpfulCount': 5,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user4',
      'userName': 'David Kim',
      'userAvatar': '',
      'locationId': 'location4',
      'locationName': 'Sunrise Organic Farm',
      'locationType': 'local farm',
      'rating': 4.7,
      'title': 'Farm-to-table excellence',
      'content':
          'The farm tour was educational and the fresh produce was incredible. The farmers are passionate about sustainable agriculture and it shows in their practices.',
      'images': [],
      'tags': ['organic', 'farm-to-table', 'educational', 'fresh produce'],
      'isVerified': true,
      'isHelpful': true,
      'helpfulCount': 15,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user5',
      'userName': 'Lisa Thompson',
      'userAvatar': '',
      'locationId': 'location5',
      'locationName': 'Eco Bistro Restaurant',
      'locationType': 'sustainable restaurant',
      'rating': 4.3,
      'title': 'Delicious sustainable dining',
      'content':
          'Every dish was made with locally sourced ingredients. The restaurant\'s commitment to zero waste and sustainable practices is commendable.',
      'images': [],
      'tags': ['local ingredients', 'zero waste', 'delicious', 'sustainable'],
      'isVerified': true,
      'isHelpful': false,
      'helpfulCount': 7,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user6',
      'userName': 'James Wilson',
      'userAvatar': '',
      'locationId': 'location6',
      'locationName': 'Forest Green Hotel',
      'locationType': 'green hotel',
      'rating': 4.6,
      'title': 'Eco-friendly luxury',
      'content':
          'This hotel proves that luxury and sustainability can coexist. The green roof, energy-efficient systems, and organic amenities made for a perfect stay.',
      'images': [],
      'tags': ['luxury', 'green roof', 'energy-efficient', 'organic'],
      'isVerified': true,
      'isHelpful': true,
      'helpfulCount': 11,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user7',
      'userName': 'Maria Garcia',
      'userAvatar': '',
      'locationId': 'location7',
      'locationName': 'Wildlife Conservation Reserve',
      'locationType': 'wildlife reserve',
      'rating': 4.9,
      'title': 'Incredible wildlife experience',
      'content':
          'The reserve does amazing work in wildlife conservation. The guided tours were educational and we saw so many animals in their natural habitat.',
      'images': [],
      'tags': ['wildlife', 'conservation', 'educational', 'natural habitat'],
      'isVerified': true,
      'isHelpful': true,
      'helpfulCount': 18,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user8',
      'userName': 'Alex Brown',
      'userAvatar': '',
      'locationId': 'location8',
      'locationName': 'Fresh Market Co-op',
      'locationType': 'organic market',
      'rating': 4.4,
      'title': 'Best organic market in town',
      'content':
          'The variety of organic produce is impressive. The market supports local farmers and the prices are reasonable for the quality.',
      'images': [],
      'tags': ['organic', 'local farmers', 'variety', 'reasonable prices'],
      'isVerified': true,
      'isHelpful': false,
      'helpfulCount': 6,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user9',
      'userName': 'Jennifer Lee',
      'userAvatar': '',
      'locationId': 'location1',
      'locationName': 'Green Valley Eco Lodge',
      'locationType': 'eco lodge',
      'rating': 4.1,
      'title': 'Good eco practices',
      'content':
          'The lodge has good sustainability practices but could improve on some amenities. The location is beautiful and the staff is friendly.',
      'images': [],
      'tags': [
        'sustainable',
        'beautiful location',
        'friendly staff',
        'amenities',
      ],
      'isVerified': false,
      'isHelpful': false,
      'helpfulCount': 3,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
    {
      'userId': 'user10',
      'userName': 'Robert Taylor',
      'userAvatar': '',
      'locationId': 'location2',
      'locationName': 'Mountain Trail Adventure',
      'locationType': 'nature trail',
      'rating': 3.8,
      'title': 'Nice trail but could be better',
      'content':
          'The trail is nice but some sections need maintenance. The eco-friendly features are good but could be more prominent.',
      'images': [],
      'tags': ['trail', 'maintenance', 'eco-friendly', 'improvement'],
      'isVerified': false,
      'isHelpful': false,
      'helpfulCount': 2,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    },
  ];

  // Populate Firestore with sample reviews
  static Future<void> populateSampleReviews() async {
    try {
      // Check if reviews already exist
      final existingReviews = await _firestore
          .collection('reviews')
          .limit(1)
          .get();

      if (existingReviews.docs.isNotEmpty) {
        print('Reviews already exist in Firestore');
        return;
      }

      // Add sample reviews to Firestore
      final batch = _firestore.batch();

      for (final reviewData in _sampleReviews) {
        final docRef = _firestore.collection('reviews').doc();
        batch.set(docRef, reviewData);
      }

      await batch.commit();
      print('Successfully populated ${_sampleReviews.length} reviews');
    } catch (e) {
      print('Error populating reviews: $e');
      throw Exception('Failed to populate reviews: $e');
    }
  }

  // Add a single review
  static Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').add(review.toFirestore());
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  // Get all reviews
  static Future<List<Review>> getAllReviews() async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  // Clear all reviews (for testing)
  static Future<void> clearAllReviews() async {
    try {
      final snapshot = await _firestore.collection('reviews').get();
      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('Successfully cleared all reviews');
    } catch (e) {
      print('Error clearing reviews: $e');
      throw Exception('Failed to clear reviews: $e');
    }
  }
}
