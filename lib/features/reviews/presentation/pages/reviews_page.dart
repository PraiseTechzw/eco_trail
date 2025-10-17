import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/reviews_provider.dart';
import '../widgets/review_card.dart';

class ReviewsPage extends ConsumerStatefulWidget {
  const ReviewsPage({super.key});

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews & Recommendations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.reviews), text: 'All Reviews'),
            Tab(icon: Icon(Icons.thumb_up), text: 'Helpful'),
            Tab(icon: Icon(Icons.trending_up), text: 'Recent'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllReviewsTab(),
          _buildHelpfulReviewsTab(),
          _buildRecentReviewsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReviewDialog(context),
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAllReviewsTab() {
    final reviewsAsync = ref.watch(filteredReviewsProvider);

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.reviews, size: 64, color: AppColors.primaryGreen),
                SizedBox(height: 16),
                Text(
                  'No Reviews Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Be the first to share your experience!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.mediumGray),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ReviewCard(
              review: review,
              onTap: () => _showReviewDetails(context, review),
              onHelpful: () => _toggleHelpful(review),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error loading reviews',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(filteredReviewsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpfulReviewsTab() {
    final helpfulReviewsAsync = ref.watch(helpfulReviewsProvider);

    return helpfulReviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up, size: 64, color: AppColors.primaryGreen),
                SizedBox(height: 16),
                Text(
                  'No Helpful Reviews Yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Reviews marked as helpful will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.mediumGray),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ReviewCard(
              review: review,
              onTap: () => _showReviewDetails(context, review),
              onHelpful: () => _toggleHelpful(review),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error loading helpful reviews',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReviewsTab() {
    final recentReviewsAsync = ref.watch(recentReviewsProvider);

    return recentReviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 64,
                  color: AppColors.primaryGreen,
                ),
                SizedBox(height: 16),
                Text(
                  'No Recent Reviews',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Recent reviews will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.mediumGray),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ReviewCard(
              review: review,
              onTap: () => _showReviewDetails(context, review),
              onHelpful: () => _toggleHelpful(review),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error loading recent reviews',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Reviews'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by title, content, or location...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            ref.read(reviewsSearchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Search is handled by the provider
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reviews'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Ratings'),
              onTap: () {
                ref.read(reviewsFilterRatingProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('5 Stars'),
              onTap: () {
                ref.read(reviewsFilterRatingProvider.notifier).state = 5.0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('4+ Stars'),
              onTap: () {
                ref.read(reviewsFilterRatingProvider.notifier).state = 4.0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('3+ Stars'),
              onTap: () {
                ref.read(reviewsFilterRatingProvider.notifier).state = 3.0;
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReviewDetails(BuildContext context, review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Review title
            Text(
              review.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),

            // Rating and date
            Row(
              children: [
                ...getRatingStars(review.rating),
                const SizedBox(width: 8),
                Text(
                  review.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGray,
                  ),
                ),
                const Spacer(),
                Text(
                  formatReviewDate(review.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Review content
            const Text(
              'Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              review.content,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                height: 1.5,
              ),
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Share review
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleHelpful(review),
                    icon: Icon(
                      review.isHelpful
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                    ),
                    label: Text(review.isHelpful ? 'Helpful' : 'Mark Helpful'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Review'),
        content: const Text(
          'This feature will be implemented in the next version.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleHelpful(review) {
    // TODO: Implement helpful toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          review.isHelpful
              ? 'Removed from helpful reviews'
              : 'Marked as helpful',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
