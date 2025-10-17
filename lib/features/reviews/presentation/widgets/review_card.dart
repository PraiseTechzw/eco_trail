import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/review_model.dart';
import '../providers/reviews_provider.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onTap;
  final VoidCallback? onHelpful;
  final bool showLocationInfo;

  const ReviewCard({
    super.key,
    required this.review,
    this.onTap,
    this.onHelpful,
    this.showLocationInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                    backgroundImage: review.userAvatar.isNotEmpty
                        ? CachedNetworkImageProvider(review.userAvatar)
                        : null,
                    child: review.userAvatar.isEmpty
                        ? Text(
                            review.userName.isNotEmpty
                                ? review.userName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // User info and rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGray,
                              ),
                            ),
                            if (review.isVerified) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...getRatingStars(review.rating, size: 14.0),
                            const SizedBox(width: 8),
                            Text(
                              review.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Date
                  Text(
                    formatReviewDate(review.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Location info (if enabled)
              if (showLocationInfo) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: getLocationTypeColor(
                      review.locationType,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getLocationTypeColor(
                        review.locationType,
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        getLocationTypeIcon(review.locationType),
                        size: 16,
                        color: getLocationTypeColor(review.locationType),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.locationName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGray,
                              ),
                            ),
                            Text(
                              review.locationType,
                              style: TextStyle(
                                fontSize: 12,
                                color: getLocationTypeColor(
                                  review.locationType,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Review title
              if (review.title.isNotEmpty) ...[
                Text(
                  review.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Review content
              Text(
                review.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGray,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (review.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: review.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.lightGreen,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Images preview
              if (review.images.isNotEmpty) ...[
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.images.length > 3
                        ? 3
                        : review.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              review.images[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: index == 2 && review.images.length > 3
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    '+${review.images.length - 3}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Footer
              Row(
                children: [
                  // Sentiment indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getSentimentColor(review.rating).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getSentimentColor(review.rating),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      getReviewSentiment(review.rating),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: getSentimentColor(review.rating),
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Helpful button
                  InkWell(
                    onTap: onHelpful,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: review.isHelpful
                            ? AppColors.primaryGreen.withOpacity(0.1)
                            : AppColors.lightGray.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: review.isHelpful
                              ? AppColors.primaryGreen
                              : AppColors.mediumGray,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            review.isHelpful
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            size: 14,
                            color: review.isHelpful
                                ? AppColors.primaryGreen
                                : AppColors.mediumGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${review.helpfulCount}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: review.isHelpful
                                  ? AppColors.primaryGreen
                                  : AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
