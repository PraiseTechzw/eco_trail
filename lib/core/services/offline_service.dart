import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineService {
  static const String _cacheBoxName = 'app_cache';
  static const String _lastSyncKey = 'last_sync';
  static const String _offlineModeKey = 'offline_mode';

  static Box? _cacheBox;
  static SharedPreferences? _prefs;

  // Initialize offline service
  static Future<void> initialize() async {
    _cacheBox = await Hive.openBox(_cacheBoxName);
    _prefs = await SharedPreferences.getInstance();
  }

  // Check if device is online
  static Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Get connectivity stream
  static Stream<ConnectivityResult> getConnectivityStream() {
    return Connectivity().onConnectivityChanged;
  }

  // Cache data
  static Future<void> cacheData(String key, dynamic data) async {
    if (_cacheBox == null) await initialize();

    try {
      final jsonString = jsonEncode(data);
      await _cacheBox!.put(key, jsonString);
      await _updateLastSync();
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  // Get cached data
  static Future<T?> getCachedData<T>(String key) async {
    if (_cacheBox == null) await initialize();

    try {
      final jsonString = _cacheBox!.get(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as T;
      }
    } catch (e) {
      print('Error getting cached data: $e');
    }
    return null;
  }

  // Remove cached data
  static Future<void> removeCachedData(String key) async {
    if (_cacheBox == null) await initialize();
    await _cacheBox!.delete(key);
  }

  // Clear all cached data
  static Future<void> clearAllCache() async {
    if (_cacheBox == null) await initialize();
    await _cacheBox!.clear();
  }

  // Check if data is cached
  static Future<bool> isDataCached(String key) async {
    if (_cacheBox == null) await initialize();
    return _cacheBox!.containsKey(key);
  }

  // Get cache size
  static Future<int> getCacheSize() async {
    if (_cacheBox == null) await initialize();
    return _cacheBox!.length;
  }

  // Set offline mode
  static Future<void> setOfflineMode(bool isOffline) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_offlineModeKey, isOffline);
  }

  // Get offline mode
  static Future<bool> getOfflineMode() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_offlineModeKey) ?? false;
  }

  // Update last sync time
  static Future<void> _updateLastSync() async {
    if (_prefs == null) await initialize();
    await _prefs!.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Get last sync time
  static Future<DateTime?> getLastSync() async {
    if (_prefs == null) await initialize();
    final lastSyncString = _prefs!.getString(_lastSyncKey);
    if (lastSyncString != null) {
      return DateTime.parse(lastSyncString);
    }
    return null;
  }

  // Check if data is stale
  static Future<bool> isDataStale(String key, Duration maxAge) async {
    final lastSync = await getLastSync();
    if (lastSync == null) return true;

    final now = DateTime.now();
    return now.difference(lastSync) > maxAge;
  }

  // Cache with expiration
  static Future<void> cacheDataWithExpiration(
    String key,
    dynamic data,
    Duration expiration,
  ) async {
    await cacheData(key, data);
    await cacheData(
      '${key}_expires',
      DateTime.now().add(expiration).toIso8601String(),
    );
  }

  // Get cached data with expiration check
  static Future<T?> getCachedDataWithExpiration<T>(String key) async {
    final expiresString = await getCachedData<String>('${key}_expires');
    if (expiresString != null) {
      final expires = DateTime.parse(expiresString);
      if (DateTime.now().isAfter(expires)) {
        await removeCachedData(key);
        await removeCachedData('${key}_expires');
        return null;
      }
    }
    return await getCachedData<T>(key);
  }

  // Cache keys
  static const String ecoLocationsKey = 'eco_locations';
  static const String eventsKey = 'events';
  static const String reviewsKey = 'reviews';
  static const String sustainabilityTipsKey = 'sustainability_tips';
  static const String userProfileKey = 'user_profile';
  static const String userBookingsKey = 'user_bookings';
  static const String userCarbonActivitiesKey = 'user_carbon_activities';

  // Cache durations
  static const Duration ecoLocationsCacheDuration = Duration(hours: 24);
  static const Duration eventsCacheDuration = Duration(hours: 6);
  static const Duration reviewsCacheDuration = Duration(hours: 12);
  static const Duration sustainabilityTipsCacheDuration = Duration(days: 7);
  static const Duration userProfileCacheDuration = Duration(hours: 1);
  static const Duration userBookingsCacheDuration = Duration(minutes: 30);
  static const Duration userCarbonActivitiesCacheDuration = Duration(hours: 2);

  // Sync data when online
  static Future<void> syncDataWhenOnline() async {
    final isOnline = await OfflineService.isOnline();
    if (!isOnline) return;

    try {
      // Sync eco locations
      await _syncEcoLocations();

      // Sync events
      await _syncEvents();

      // Sync reviews
      await _syncReviews();

      // Sync sustainability tips
      await _syncSustainabilityTips();

      // Sync user data
      await _syncUserData();

      await _updateLastSync();
    } catch (e) {
      print('Error syncing data: $e');
    }
  }

  // Sync eco locations
  static Future<void> _syncEcoLocations() async {
    // This would typically fetch from Firebase and cache
    // For now, we'll just update the last sync time
    print('Syncing eco locations...');
  }

  // Sync events
  static Future<void> _syncEvents() async {
    print('Syncing events...');
  }

  // Sync reviews
  static Future<void> _syncReviews() async {
    print('Syncing reviews...');
  }

  // Sync sustainability tips
  static Future<void> _syncSustainabilityTips() async {
    print('Syncing sustainability tips...');
  }

  // Sync user data
  static Future<void> _syncUserData() async {
    print('Syncing user data...');
  }

  // Get cache statistics
  static Future<Map<String, dynamic>> getCacheStatistics() async {
    if (_cacheBox == null) await initialize();

    final lastSync = await getLastSync();
    final cacheSize = await getCacheSize();
    final isOffline = await getOfflineMode();

    return {
      'lastSync': lastSync?.toIso8601String(),
      'cacheSize': cacheSize,
      'isOffline': isOffline,
      'isOnline': await isOnline(),
    };
  }

  // Clean up old cache
  static Future<void> cleanupOldCache() async {
    if (_cacheBox == null) await initialize();

    final keys = _cacheBox!.keys.toList();
    final now = DateTime.now();

    for (final key in keys) {
      if (key.toString().endsWith('_expires')) {
        final expiresString = _cacheBox!.get(key);
        if (expiresString != null) {
          final expires = DateTime.parse(expiresString);
          if (now.isAfter(expires)) {
            final dataKey = key.toString().replaceAll('_expires', '');
            await removeCachedData(dataKey);
            await removeCachedData(key.toString());
          }
        }
      }
    }
  }
}
