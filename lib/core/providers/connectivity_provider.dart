import 'package:eco_trail/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/offline_service.dart';

// Connectivity state provider
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return OfflineService.getConnectivityStream();
});

// Online status provider
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true, // Assume online while loading
    error: (_, __) => false, // Assume offline on error
  );
});

// Offline mode provider
final offlineModeProvider = StateNotifierProvider<OfflineModeNotifier, bool>((ref) {
  return OfflineModeNotifier();
});

class OfflineModeNotifier extends StateNotifier<bool> {
  OfflineModeNotifier() : super(false) {
    _loadOfflineMode();
  }

  Future<void> _loadOfflineMode() async {
    final isOffline = await OfflineService.getOfflineMode();
    state = isOffline;
  }

  Future<void> setOfflineMode(bool isOffline) async {
    await OfflineService.setOfflineMode(isOffline);
    state = isOffline;
  }

  Future<void> toggleOfflineMode() async {
    await setOfflineMode(!state);
  }
}

// Cache statistics provider
final cacheStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return OfflineService.getCacheStatistics();
});

// Last sync provider
final lastSyncProvider = FutureProvider<DateTime?>((ref) {
  return OfflineService.getLastSync();
});

// Data staleness provider
final dataStalenessProvider = Provider.family<bool, String>((ref, key) {
  // This would typically check if data is stale
  // For now, we'll return false (not stale)
  return false;
});

// Offline status provider
final offlineStatusProvider = Provider<OfflineStatus>((ref) {
  final isOnline = ref.watch(isOnlineProvider);
  final offlineMode = ref.watch(offlineModeProvider);
  
  if (offlineMode) {
    return OfflineStatus.offlineMode;
  } else if (!isOnline) {
    return OfflineStatus.noConnection;
  } else {
    return OfflineStatus.online;
  }
});

enum OfflineStatus {
  online,
  noConnection,
  offlineMode,
}

// Helper function to get offline status text
String getOfflineStatusText(OfflineStatus status) {
  switch (status) {
    case OfflineStatus.online:
      return 'Online';
    case OfflineStatus.noConnection:
      return 'No Connection';
    case OfflineStatus.offlineMode:
      return 'Offline Mode';
  }
}

// Helper function to get offline status color


Color getOfflineStatusColor(OfflineStatus status) {
  switch (status) {
    case OfflineStatus.online:
      return AppColors.success;
    case OfflineStatus.noConnection:
      return AppColors.error;
    case OfflineStatus.offlineMode:
      return AppColors.warning;
  }
}

// Helper function to get offline status icon
IconData getOfflineStatusIcon(OfflineStatus status) {
  switch (status) {
    case OfflineStatus.online:
      return Icons.wifi;
    case OfflineStatus.noConnection:
      return Icons.wifi_off;
    case OfflineStatus.offlineMode:
      return Icons.airplanemode_active;
  }
}
