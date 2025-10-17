import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/tips_provider.dart';
import '../widgets/sustainability_tip_card.dart';
import '../widgets/carbon_tracker_widget.dart';

class TipsPage extends ConsumerStatefulWidget {
  const TipsPage({super.key});

  @override
  ConsumerState<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends ConsumerState<TipsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Sustainability Tips'),
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
            Tab(icon: Icon(Icons.lightbulb), text: 'Tips'),
            Tab(icon: Icon(Icons.eco), text: 'Carbon Tracker'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTipsTab(), _buildCarbonTrackerTab()],
      ),
    );
  }

  Widget _buildTipsTab() {
    final tipsAsync = ref.watch(filteredTipsProvider);

    return tipsAsync.when(
      data: (tips) {
        if (tips.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, size: 64, color: AppColors.primaryGreen),
                SizedBox(height: 16),
                Text(
                  'No Tips Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.mediumGray),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: tips.length,
          itemBuilder: (context, index) {
            final tip = tips[index];
            return SustainabilityTipCard(
              tip: tip,
              onTap: () => _showTipDetails(context, tip),
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
              'Error loading tips',
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
              onPressed: () => ref.refresh(filteredTipsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarbonTrackerTab() {
    // For demo purposes, using a dummy user ID
    // In a real app, you'd get this from authentication
    const userId = 'demo_user_id';

    return SingleChildScrollView(
      child: Column(
        children: [
          CarbonTrackerWidget(userId: userId),
          const SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildQuickActionCard(
                  'Add Transport',
                  Icons.directions_car,
                  AppColors.primaryGreen,
                  () => _showAddActivityDialog('transport'),
                ),
                _buildQuickActionCard(
                  'Add Energy',
                  Icons.flash_on,
                  Colors.orange,
                  () => _showAddActivityDialog('energy'),
                ),
                _buildQuickActionCard(
                  'Add Food',
                  Icons.restaurant,
                  Colors.brown,
                  () => _showAddActivityDialog('food'),
                ),
                _buildQuickActionCard(
                  'View Analytics',
                  Icons.analytics,
                  AppColors.secondaryGreen,
                  () => _showAnalyticsDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
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
        title: const Text('Search Tips'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by title, category, or tags...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            ref.read(tipsSearchQueryProvider.notifier).state = value;
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
    final categories = ref.read(tipCategoriesProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Categories'),
              onTap: () {
                ref.read(tipsFilterCategoryProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
            ...categories.map(
              (category) => ListTile(
                title: Text(category),
                onTap: () {
                  ref.read(tipsFilterCategoryProvider.notifier).state =
                      category;
                  Navigator.pop(context);
                },
              ),
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

  void _showTipDetails(BuildContext context, tip) {
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

            // Tip title
            Text(
              tip.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),

            // Category and difficulty
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getCategoryColor(tip.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tip.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: getCategoryColor(tip.category),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getDifficultyColor(tip.difficulty).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tip.difficulty,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: getDifficultyColor(tip.difficulty),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Impact indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: getImpactColor(tip.estimatedImpact).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: getImpactColor(tip.estimatedImpact),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_down,
                    color: getImpactColor(tip.estimatedImpact),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Impact',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGray,
                          ),
                        ),
                        Text(
                          '${tip.estimatedImpact}kg CO₂ saved per month',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: getImpactColor(tip.estimatedImpact),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tip.description,
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
                      // TODO: Share tip
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Mark as completed
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Mark Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddActivityDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${type.capitalize()} Activity'),
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

  void _showAnalyticsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Carbon Analytics'),
        content: const Text(
          'Detailed analytics will be available in the next version.',
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
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
