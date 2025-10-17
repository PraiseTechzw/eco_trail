import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connectivity_provider.dart';
import '../theme/app_colors.dart';

class OfflineIndicator extends ConsumerWidget {
  final Widget child;
  final bool showBanner;

  const OfflineIndicator({
    super.key,
    required this.child,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineStatus = ref.watch(offlineStatusProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return Stack(
      children: [
        child,
        if (showBanner && !isOnline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: getOfflineStatusColor(offlineStatus),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    getOfflineStatusIcon(offlineStatus),
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      getOfflineStatusText(offlineStatus),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (offlineStatus == OfflineStatus.offlineMode)
                    TextButton(
                      onPressed: () {
                        ref
                            .read(offlineModeProvider.notifier)
                            .setOfflineMode(false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Go Online'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class OfflineStatusBar extends ConsumerWidget {
  const OfflineStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineStatus = ref.watch(offlineStatusProvider);
    final isOnline = ref.watch(isOnlineProvider);

    if (isOnline) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: getOfflineStatusColor(offlineStatus),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            getOfflineStatusIcon(offlineStatus),
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              getOfflineStatusText(offlineStatus),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (offlineStatus == OfflineStatus.offlineMode)
            TextButton(
              onPressed: () {
                ref.read(offlineModeProvider.notifier).setOfflineMode(false);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Go Online'),
            ),
        ],
      ),
    );
  }
}

class OfflineModeToggle extends ConsumerWidget {
  const OfflineModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineMode = ref.watch(offlineModeProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return SwitchListTile(
      title: const Text('Offline Mode'),
      subtitle: Text(
        offlineMode
            ? 'Using cached data only'
            : isOnline
            ? 'Online - data will sync automatically'
            : 'No internet connection',
      ),
      value: offlineMode,
      onChanged: isOnline
          ? (value) {
              ref.read(offlineModeProvider.notifier).setOfflineMode(value);
            }
          : null,
      secondary: Icon(
        offlineMode ? Icons.airplanemode_active : Icons.wifi,
        color: offlineMode ? AppColors.warning : AppColors.success,
      ),
    );
  }
}

class CacheStatisticsWidget extends ConsumerWidget {
  const CacheStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheStatsAsync = ref.watch(cacheStatisticsProvider);

    return cacheStatsAsync.when(
      data: (stats) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cache Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatRow('Cache Size', '${stats['cacheSize']} items'),
              _buildStatRow('Last Sync', stats['lastSync'] ?? 'Never'),
              _buildStatRow('Status', stats['isOnline'] ? 'Online' : 'Offline'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Clear cache
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cache cleared'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Text('Clear Cache'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Sync data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data synced'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Text('Sync Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading cache statistics: $error')),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
