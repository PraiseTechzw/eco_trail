import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/reviews_service.dart';
import '../../data/models/review_model.dart';
import '../../../../core/theme/app_colors.dart';

// All reviews provider
final allReviewsProvider = StreamProvider<List<Review>>((ref) {
  return ReviewsService.getAllReviews();
});

// Location reviews provider
final locationReviewsProvider = StreamProvider.family<List<Review>, String>((
  ref,
  locationId,
) {
  return ReviewsService.getLocationReviews(locationId);
});

// User reviews provider
final userReviewsProvider = StreamProvider.family<List<Review>, String>((
  ref,
  userId,
) {
  return ReviewsService.getUserReviews(userId);
});

// Selected review provider
final selectedReviewProvider = StateProvider<Review?>((ref) => null);

// Search query provider
final reviewsSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter rating provider
final reviewsFilterRatingProvider = StateProvider<double?>((ref) => null);

// Filter location type provider
final reviewsFilterLocationTypeProvider = StateProvider<String?>((ref) => null);

// Filtered reviews provider
final filteredReviewsProvider = FutureProvider<List<Review>>((ref) async {
  final searchQuery = ref.watch(reviewsSearchQueryProvider);
  final filterRating = ref.watch(reviewsFilterRatingProvider);
  final filterLocationType = ref.watch(reviewsFilterLocationTypeProvider);

  if (searchQuery.isNotEmpty) {
    return ReviewsService.searchReviews(searchQuery);
  } else if (filterRating != null) {
    return ReviewsService.getReviewsByRating(filterRating);
  } else if (filterLocationType != null) {
    return ReviewsService.getReviewsByLocationType(filterLocationType);
  } else {
    // Return recent reviews
    return ReviewsService.getRecentReviews();
  }
});

// Location rating summary provider
final locationRatingSummaryProvider =
    StreamProvider.family<ReviewSummary?, String>((ref, locationId) {
      return ReviewsService.getLocationRatingSummaryStream(locationId);
    });

// Helpful reviews provider
final helpfulReviewsProvider = FutureProvider<List<Review>>((ref) {
  return ReviewsService.getHelpfulReviews();
});

// Recent reviews provider
final recentReviewsProvider = FutureProvider<List<Review>>((ref) {
  return ReviewsService.getRecentReviews();
});

// Helper function to get rating color

Color getRatingColor(double rating) {
  if (rating >= 4.5) {
    return AppColors.success;
  } else if (rating >= 3.5) {
    return AppColors.warning;
  } else if (rating >= 2.5) {
    return AppColors.info;
  } else {
    return AppColors.error;
  }
}

// Helper function to get rating text
String getRatingText(double rating) {
  if (rating >= 4.5) {
    return 'Excellent';
  } else if (rating >= 3.5) {
    return 'Good';
  } else if (rating >= 2.5) {
    return 'Average';
  } else if (rating >= 1.5) {
    return 'Poor';
  } else {
    return 'Very Poor';
  }
}

// Helper function to format date
String formatReviewDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}

// Helper function to get location type icon
IconData getLocationTypeIcon(String locationType) {
  switch (locationType.toLowerCase()) {
    case 'eco lodge':
      return Icons.nature_people;
    case 'nature trail':
      return Icons.hiking;
    case 'cultural site':
      return Icons.museum;
    case 'local farm':
      return Icons.agriculture;
    case 'sustainable restaurant':
      return Icons.restaurant;
    case 'green hotel':
      return Icons.hotel;
    case 'wildlife reserve':
      return Icons.pets;
    case 'organic market':
      return Icons.store;
    default:
      return Icons.location_on;
  }
}

// Helper function to get location type color
Color getLocationTypeColor(String locationType) {
  switch (locationType.toLowerCase()) {
    case 'eco lodge':
      return AppColors.primaryGreen;
    case 'nature trail':
      return Colors.brown;
    case 'cultural site':
      return Colors.orange;
    case 'local farm':
      return Colors.green;
    case 'sustainable restaurant':
      return Colors.red;
    case 'green hotel':
      return Colors.blue;
    case 'wildlife reserve':
      return Colors.purple;
    case 'organic market':
      return Colors.amber;
    default:
      return AppColors.mediumGray;
  }
}

// Helper function to get rating stars
List<Widget> getRatingStars(double rating, {double size = 16.0}) {
  final stars = <Widget>[];
  final fullStars = rating.floor();
  final hasHalfStar = rating - fullStars >= 0.5;

  for (int i = 0; i < fullStars; i++) {
    stars.add(Icon(Icons.star, color: Colors.amber, size: size));
  }

  if (hasHalfStar) {
    stars.add(Icon(Icons.star_half, color: Colors.amber, size: size));
  }

  final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
  for (int i = 0; i < emptyStars; i++) {
    stars.add(Icon(Icons.star_border, color: Colors.amber, size: size));
  }

  return stars;
}

// Helper function to get review sentiment
String getReviewSentiment(double rating) {
  if (rating >= 4.0) {
    return 'Positive';
  } else if (rating >= 3.0) {
    return 'Neutral';
  } else {
    return 'Negative';
  }
}

// Helper function to get sentiment color
Color getSentimentColor(double rating) {
  if (rating >= 4.0) {
    return AppColors.success;
  } else if (rating >= 3.0) {
    return AppColors.warning;
  } else {
    return AppColors.error;
  }
}
