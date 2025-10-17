import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new review
  static Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').add(review.toFirestore());

      // Update location rating summary
      await _updateLocationRatingSummary(review.locationId);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  // Get reviews for a specific location
  static Stream<List<Review>> getLocationReviews(String locationId) {
    return _firestore
        .collection('reviews')
        .where('locationId', isEqualTo: locationId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList(),
        );
  }

  // Get user's reviews
  static Stream<List<Review>> getUserReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList(),
        );
  }

  // Get all reviews
  static Stream<List<Review>> getAllReviews() {
    return _firestore
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList(),
        );
  }

  // Search reviews
  static Future<List<Review>> searchReviews(String query) async {
    try {
      final snapshot = await _firestore.collection('reviews').get();

      final allReviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();

      if (query.isEmpty) return allReviews;

      return allReviews.where((review) {
        return review.title.toLowerCase().contains(query.toLowerCase()) ||
            review.content.toLowerCase().contains(query.toLowerCase()) ||
            review.locationName.toLowerCase().contains(query.toLowerCase()) ||
            review.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search reviews: $e');
    }
  }

  // Filter reviews by rating
  static Future<List<Review>> getReviewsByRating(double minRating) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('rating', isGreaterThanOrEqualTo: minRating)
          .orderBy('rating', descending: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get reviews by rating: $e');
    }
  }

  // Filter reviews by location type
  static Future<List<Review>> getReviewsByLocationType(
    String locationType,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('locationType', isEqualTo: locationType)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get reviews by location type: $e');
    }
  }

  // Get review summary for a location
  static Future<ReviewSummary> getLocationReviewSummary(
    String locationId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('locationId', isEqualTo: locationId)
          .get();

      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();

      if (reviews.isEmpty) {
        return ReviewSummary(
          locationId: locationId,
          averageRating: 0.0,
          totalReviews: 0,
          ratingDistribution: {},
          commonTags: [],
          lastUpdated: DateTime.now(),
        );
      }

      // Calculate average rating
      final totalRating = reviews.fold(
        0.0,
        (sum, review) => sum + review.rating,
      );
      final averageRating = totalRating / reviews.length;

      // Calculate rating distribution
      final ratingDistribution = <int, int>{};
      for (final review in reviews) {
        final rating = review.rating.round();
        ratingDistribution[rating] = (ratingDistribution[rating] ?? 0) + 1;
      }

      // Get common tags
      final tagCounts = <String, int>{};
      for (final review in reviews) {
        for (final tag in review.tags) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }
      final commonTags = tagCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topTags = commonTags.take(5).map((e) => e.key).toList();

      return ReviewSummary(
        locationId: locationId,
        averageRating: averageRating,
        totalReviews: reviews.length,
        ratingDistribution: ratingDistribution,
        commonTags: topTags,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get review summary: $e');
    }
  }

  // Get review summary stream
  static Stream<ReviewSummary> getLocationReviewSummaryStream(
    String locationId,
  ) {
    return Stream.periodic(
      const Duration(minutes: 1),
    ).asyncMap((_) => getLocationReviewSummary(locationId));
  }

  // Update review
  static Future<void> updateReview(
    String reviewId,
    Review updatedReview,
  ) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(reviewId)
          .update(updatedReview.toFirestore());

      // Update location rating summary
      await _updateLocationRatingSummary(updatedReview.locationId);
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  // Delete review
  static Future<void> deleteReview(String reviewId, String locationId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();

      // Update location rating summary
      await _updateLocationRatingSummary(locationId);
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  // Mark review as helpful
  static Future<void> markReviewAsHelpful(
    String reviewId,
    bool isHelpful,
  ) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'isHelpful': isHelpful,
        'helpfulCount': FieldValue.increment(isHelpful ? 1 : -1),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to mark review as helpful: $e');
    }
  }

  // Get helpful reviews
  static Future<List<Review>> getHelpfulReviews() async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('isHelpful', isEqualTo: true)
          .orderBy('helpfulCount', descending: true)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get helpful reviews: $e');
    }
  }

  // Get recent reviews
  static Future<List<Review>> getRecentReviews({int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get recent reviews: $e');
    }
  }

  // Update location rating summary
  static Future<void> _updateLocationRatingSummary(String locationId) async {
    try {
      final summary = await getLocationReviewSummary(locationId);

      await _firestore
          .collection('location_ratings')
          .doc(locationId)
          .set(summary.toMap());
    } catch (e) {
      print('Error updating location rating summary: $e');
    }
  }

  // Get location rating summary
  static Future<ReviewSummary?> getLocationRatingSummary(
    String locationId,
  ) async {
    try {
      final doc = await _firestore
          .collection('location_ratings')
          .doc(locationId)
          .get();

      if (doc.exists) {
        return ReviewSummary.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get location rating summary: $e');
    }
  }

  // Get location rating summary stream
  static Stream<ReviewSummary?> getLocationRatingSummaryStream(
    String locationId,
  ) {
    return _firestore
        .collection('location_ratings')
        .doc(locationId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return ReviewSummary.fromMap(doc.data()!);
          }
          return null;
        });
  }
}
