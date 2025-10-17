import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityService {
  static const String _fontScaleKey = 'font_scale';
  static const String _highContrastKey = 'high_contrast';
  static const String _reduceMotionKey = 'reduce_motion';
  static const String _screenReaderKey = 'screen_reader';
  static const String _largeTextKey = 'large_text';
  static const String _boldTextKey = 'bold_text';
  static const String _colorBlindKey = 'color_blind';
  static const String _voiceOverKey = 'voice_over';

  static SharedPreferences? _prefs;

  // Initialize accessibility service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Font scale
  static Future<double> getFontScale() async {
    if (_prefs == null) await initialize();
    return _prefs!.getDouble(_fontScaleKey) ?? 1.0;
  }

  static Future<void> setFontScale(double scale) async {
    if (_prefs == null) await initialize();
    await _prefs!.setDouble(_fontScaleKey, scale);
  }

  // High contrast
  static Future<bool> getHighContrast() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_highContrastKey) ?? false;
  }

  static Future<void> setHighContrast(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_highContrastKey, enabled);
  }

  // Reduce motion
  static Future<bool> getReduceMotion() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_reduceMotionKey) ?? false;
  }

  static Future<void> setReduceMotion(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_reduceMotionKey, enabled);
  }

  // Screen reader
  static Future<bool> getScreenReader() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_screenReaderKey) ?? false;
  }

  static Future<void> setScreenReader(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_screenReaderKey, enabled);
  }

  // Large text
  static Future<bool> getLargeText() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_largeTextKey) ?? false;
  }

  static Future<void> setLargeText(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_largeTextKey, enabled);
  }

  // Bold text
  static Future<bool> getBoldText() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_boldTextKey) ?? false;
  }

  static Future<void> setBoldText(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_boldTextKey, enabled);
  }

  // Color blind support
  static Future<bool> getColorBlind() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_colorBlindKey) ?? false;
  }

  static Future<void> setColorBlind(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_colorBlindKey, enabled);
  }

  // Voice over
  static Future<bool> getVoiceOver() async {
    if (_prefs == null) await initialize();
    return _prefs!.getBool(_voiceOverKey) ?? false;
  }

  static Future<void> setVoiceOver(bool enabled) async {
    if (_prefs == null) await initialize();
    await _prefs!.setBool(_voiceOverKey, enabled);
  }

  // Get all accessibility settings
  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'fontScale': await getFontScale(),
      'highContrast': await getHighContrast(),
      'reduceMotion': await getReduceMotion(),
      'screenReader': await getScreenReader(),
      'largeText': await getLargeText(),
      'boldText': await getBoldText(),
      'colorBlind': await getColorBlind(),
      'voiceOver': await getVoiceOver(),
    };
  }

  // Set all accessibility settings
  static Future<void> setAllSettings(Map<String, dynamic> settings) async {
    if (settings.containsKey('fontScale')) {
      await setFontScale(settings['fontScale']);
    }
    if (settings.containsKey('highContrast')) {
      await setHighContrast(settings['highContrast']);
    }
    if (settings.containsKey('reduceMotion')) {
      await setReduceMotion(settings['reduceMotion']);
    }
    if (settings.containsKey('screenReader')) {
      await setScreenReader(settings['screenReader']);
    }
    if (settings.containsKey('largeText')) {
      await setLargeText(settings['largeText']);
    }
    if (settings.containsKey('boldText')) {
      await setBoldText(settings['boldText']);
    }
    if (settings.containsKey('colorBlind')) {
      await setColorBlind(settings['colorBlind']);
    }
    if (settings.containsKey('voiceOver')) {
      await setVoiceOver(settings['voiceOver']);
    }
  }

  // Reset all settings to default
  static Future<void> resetToDefault() async {
    await setFontScale(1.0);
    await setHighContrast(false);
    await setReduceMotion(false);
    await setScreenReader(false);
    await setLargeText(false);
    await setBoldText(false);
    await setColorBlind(false);
    await setVoiceOver(false);
  }

  // Check if accessibility features are enabled
  static Future<bool> hasAccessibilityFeatures() async {
    final settings = await getAllSettings();
    return settings.values.any((value) => value == true) ||
        settings['fontScale'] != 1.0;
  }

  // Get accessibility level
  static Future<AccessibilityLevel> getAccessibilityLevel() async {
    final settings = await getAllSettings();
    int score = 0;

    if (settings['fontScale'] > 1.0) score++;
    if (settings['highContrast']) score++;
    if (settings['reduceMotion']) score++;
    if (settings['screenReader']) score++;
    if (settings['largeText']) score++;
    if (settings['boldText']) score++;
    if (settings['colorBlind']) score++;
    if (settings['voiceOver']) score++;

    if (score >= 6) return AccessibilityLevel.high;
    if (score >= 3) return AccessibilityLevel.medium;
    if (score >= 1) return AccessibilityLevel.low;
    return AccessibilityLevel.none;
  }

  // Get accessibility recommendations
  static Future<List<String>> getAccessibilityRecommendations() async {
    final settings = await getAllSettings();
    final recommendations = <String>[];

    if (settings['fontScale'] == 1.0) {
      recommendations.add(
        'Consider increasing font size for better readability',
      );
    }

    if (!settings['highContrast']) {
      recommendations.add('Enable high contrast for better visibility');
    }

    if (!settings['reduceMotion']) {
      recommendations.add('Enable reduced motion for a calmer experience');
    }

    if (!settings['screenReader']) {
      recommendations.add('Enable screen reader support for better navigation');
    }

    if (!settings['largeText']) {
      recommendations.add('Enable large text for easier reading');
    }

    if (!settings['boldText']) {
      recommendations.add('Enable bold text for better text visibility');
    }

    if (!settings['colorBlind']) {
      recommendations.add(
        'Enable color blind support for better color perception',
      );
    }

    if (!settings['voiceOver']) {
      recommendations.add('Enable voice over for audio navigation');
    }

    return recommendations;
  }

  // Get accessibility statistics
  static Future<Map<String, dynamic>> getAccessibilityStatistics() async {
    final settings = await getAllSettings();
    final level = await getAccessibilityLevel();
    final recommendations = await getAccessibilityRecommendations();

    return {
      'level': level.toString(),
      'score': _getAccessibilityScore(settings),
      'totalFeatures': 8,
      'enabledFeatures': _getEnabledFeaturesCount(settings),
      'recommendations': recommendations,
      'settings': settings,
    };
  }

  // Get accessibility score
  static int _getAccessibilityScore(Map<String, dynamic> settings) {
    int score = 0;

    if (settings['fontScale'] > 1.0) score++;
    if (settings['highContrast']) score++;
    if (settings['reduceMotion']) score++;
    if (settings['screenReader']) score++;
    if (settings['largeText']) score++;
    if (settings['boldText']) score++;
    if (settings['colorBlind']) score++;
    if (settings['voiceOver']) score++;

    return score;
  }

  // Get enabled features count
  static int _getEnabledFeaturesCount(Map<String, dynamic> settings) {
    int count = 0;

    if (settings['fontScale'] > 1.0) count++;
    if (settings['highContrast']) count++;
    if (settings['reduceMotion']) count++;
    if (settings['screenReader']) count++;
    if (settings['largeText']) count++;
    if (settings['boldText']) count++;
    if (settings['colorBlind']) count++;
    if (settings['voiceOver']) count++;

    return count;
  }
}

enum AccessibilityLevel { none, low, medium, high }

extension AccessibilityLevelExtension on AccessibilityLevel {
  String get displayName {
    switch (this) {
      case AccessibilityLevel.none:
        return 'None';
      case AccessibilityLevel.low:
        return 'Low';
      case AccessibilityLevel.medium:
        return 'Medium';
      case AccessibilityLevel.high:
        return 'High';
    }
  }

  String get description {
    switch (this) {
      case AccessibilityLevel.none:
        return 'No accessibility features enabled';
      case AccessibilityLevel.low:
        return 'Basic accessibility features enabled';
      case AccessibilityLevel.medium:
        return 'Moderate accessibility features enabled';
      case AccessibilityLevel.high:
        return 'Comprehensive accessibility features enabled';
    }
  }

  Color get color {
    switch (this) {
      case AccessibilityLevel.none:
        return Colors.grey;
      case AccessibilityLevel.low:
        return Colors.orange;
      case AccessibilityLevel.medium:
        return Colors.blue;
      case AccessibilityLevel.high:
        return Colors.green;
    }
  }
}
