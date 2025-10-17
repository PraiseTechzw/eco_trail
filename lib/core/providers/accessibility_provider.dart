import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/accessibility_service.dart';

// Font scale provider
final fontScaleProvider = StateNotifierProvider<FontScaleNotifier, double>((
  ref,
) {
  return FontScaleNotifier();
});

class FontScaleNotifier extends StateNotifier<double> {
  FontScaleNotifier() : super(1.0) {
    _loadFontScale();
  }

  Future<void> _loadFontScale() async {
    final fontScale = await AccessibilityService.getFontScale();
    state = fontScale;
  }

  Future<void> setFontScale(double scale) async {
    await AccessibilityService.setFontScale(scale);
    state = scale;
  }
}

// High contrast provider
final highContrastProvider = StateNotifierProvider<HighContrastNotifier, bool>((
  ref,
) {
  return HighContrastNotifier();
});

class HighContrastNotifier extends StateNotifier<bool> {
  HighContrastNotifier() : super(false) {
    _loadHighContrast();
  }

  Future<void> _loadHighContrast() async {
    final highContrast = await AccessibilityService.getHighContrast();
    state = highContrast;
  }

  Future<void> setHighContrast(bool enabled) async {
    await AccessibilityService.setHighContrast(enabled);
    state = enabled;
  }
}

// Reduce motion provider
final reduceMotionProvider = StateNotifierProvider<ReduceMotionNotifier, bool>((
  ref,
) {
  return ReduceMotionNotifier();
});

class ReduceMotionNotifier extends StateNotifier<bool> {
  ReduceMotionNotifier() : super(false) {
    _loadReduceMotion();
  }

  Future<void> _loadReduceMotion() async {
    final reduceMotion = await AccessibilityService.getReduceMotion();
    state = reduceMotion;
  }

  Future<void> setReduceMotion(bool enabled) async {
    await AccessibilityService.setReduceMotion(enabled);
    state = enabled;
  }
}

// Screen reader provider
final screenReaderProvider = StateNotifierProvider<ScreenReaderNotifier, bool>((
  ref,
) {
  return ScreenReaderNotifier();
});

class ScreenReaderNotifier extends StateNotifier<bool> {
  ScreenReaderNotifier() : super(false) {
    _loadScreenReader();
  }

  Future<void> _loadScreenReader() async {
    final screenReader = await AccessibilityService.getScreenReader();
    state = screenReader;
  }

  Future<void> setScreenReader(bool enabled) async {
    await AccessibilityService.setScreenReader(enabled);
    state = enabled;
  }
}

// Large text provider
final largeTextProvider = StateNotifierProvider<LargeTextNotifier, bool>((ref) {
  return LargeTextNotifier();
});

class LargeTextNotifier extends StateNotifier<bool> {
  LargeTextNotifier() : super(false) {
    _loadLargeText();
  }

  Future<void> _loadLargeText() async {
    final largeText = await AccessibilityService.getLargeText();
    state = largeText;
  }

  Future<void> setLargeText(bool enabled) async {
    await AccessibilityService.setLargeText(enabled);
    state = enabled;
  }
}

// Bold text provider
final boldTextProvider = StateNotifierProvider<BoldTextNotifier, bool>((ref) {
  return BoldTextNotifier();
});

class BoldTextNotifier extends StateNotifier<bool> {
  BoldTextNotifier() : super(false) {
    _loadBoldText();
  }

  Future<void> _loadBoldText() async {
    final boldText = await AccessibilityService.getBoldText();
    state = boldText;
  }

  Future<void> setBoldText(bool enabled) async {
    await AccessibilityService.setBoldText(enabled);
    state = enabled;
  }
}

// Color blind provider
final colorBlindProvider = StateNotifierProvider<ColorBlindNotifier, bool>((
  ref,
) {
  return ColorBlindNotifier();
});

class ColorBlindNotifier extends StateNotifier<bool> {
  ColorBlindNotifier() : super(false) {
    _loadColorBlind();
  }

  Future<void> _loadColorBlind() async {
    final colorBlind = await AccessibilityService.getColorBlind();
    state = colorBlind;
  }

  Future<void> setColorBlind(bool enabled) async {
    await AccessibilityService.setColorBlind(enabled);
    state = enabled;
  }
}

// Voice over provider
final voiceOverProvider = StateNotifierProvider<VoiceOverNotifier, bool>((ref) {
  return VoiceOverNotifier();
});

class VoiceOverNotifier extends StateNotifier<bool> {
  VoiceOverNotifier() : super(false) {
    _loadVoiceOver();
  }

  Future<void> _loadVoiceOver() async {
    final voiceOver = await AccessibilityService.getVoiceOver();
    state = voiceOver;
  }

  Future<void> setVoiceOver(bool enabled) async {
    await AccessibilityService.setVoiceOver(enabled);
    state = enabled;
  }
}

// All accessibility settings provider
final allAccessibilitySettingsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) {
  return AccessibilityService.getAllSettings();
});

// Accessibility level provider
final accessibilityLevelProvider = FutureProvider<AccessibilityLevel>((ref) {
  return AccessibilityService.getAccessibilityLevel();
});

// Accessibility recommendations provider
final accessibilityRecommendationsProvider = FutureProvider<List<String>>((
  ref,
) {
  return AccessibilityService.getAccessibilityRecommendations();
});

// Accessibility statistics provider
final accessibilityStatisticsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) {
  return AccessibilityService.getAccessibilityStatistics();
});

// Has accessibility features provider
final hasAccessibilityFeaturesProvider = FutureProvider<bool>((ref) {
  return AccessibilityService.hasAccessibilityFeatures();
});

// Accessibility level display name provider
final accessibilityLevelDisplayNameProvider = Provider<String>((ref) {
  final levelAsync = ref.watch(accessibilityLevelProvider);
  return levelAsync.when(
    data: (level) => level.displayName,
    loading: () => 'Loading...',
    error: (_, __) => 'Error',
  );
});

// Accessibility level description provider
final accessibilityLevelDescriptionProvider = Provider<String>((ref) {
  final levelAsync = ref.watch(accessibilityLevelProvider);
  return levelAsync.when(
    data: (level) => level.description,
    loading: () => 'Loading...',
    error: (_, __) => 'Error',
  );
});

// Accessibility level color provider
final accessibilityLevelColorProvider = Provider<Color>((ref) {
  final levelAsync = ref.watch(accessibilityLevelProvider);
  return levelAsync.when(
    data: (level) => level.color,
    loading: () => Colors.grey,
    error: (_, __) => Colors.grey,
  );
});

// Accessibility score provider
final accessibilityScoreProvider = Provider<int>((ref) {
  final statsAsync = ref.watch(accessibilityStatisticsProvider);
  return statsAsync.when(
    data: (stats) => stats['score'] ?? 0,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Enabled features count provider
final enabledFeaturesCountProvider = Provider<int>((ref) {
  final statsAsync = ref.watch(accessibilityStatisticsProvider);
  return statsAsync.when(
    data: (stats) => stats['enabledFeatures'] ?? 0,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Total features count provider
final totalFeaturesCountProvider = Provider<int>((ref) {
  final statsAsync = ref.watch(accessibilityStatisticsProvider);
  return statsAsync.when(
    data: (stats) => stats['totalFeatures'] ?? 8,
    loading: () => 8,
    error: (_, __) => 8,
  );
});

// Accessibility progress provider
final accessibilityProgressProvider = Provider<double>((ref) {
  final enabled = ref.watch(enabledFeaturesCountProvider);
  final total = ref.watch(totalFeaturesCountProvider);
  return total > 0 ? enabled / total : 0.0;
});

// Accessibility progress percentage provider
final accessibilityProgressPercentageProvider = Provider<int>((ref) {
  final progress = ref.watch(accessibilityProgressProvider);
  return (progress * 100).round();
});

// Accessibility progress text provider
final accessibilityProgressTextProvider = Provider<String>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  return '$percentage%';
});

// Accessibility progress color provider
final accessibilityProgressColorProvider = Provider<Color>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return Colors.green;
  if (percentage >= 50) return Colors.blue;
  if (percentage >= 25) return Colors.orange;
  return Colors.red;
});

// Accessibility progress description provider
final accessibilityProgressDescriptionProvider = Provider<String>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return 'Excellent accessibility support';
  if (percentage >= 50) return 'Good accessibility support';
  if (percentage >= 25) return 'Basic accessibility support';
  return 'Limited accessibility support';
});

// Accessibility progress icon provider
final accessibilityProgressIconProvider = Provider<IconData>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return Icons.check_circle;
  if (percentage >= 50) return Icons.info;
  if (percentage >= 25) return Icons.warning;
  return Icons.error;
});

// Accessibility progress icon color provider
final accessibilityProgressIconColorProvider = Provider<Color>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return Colors.green;
  if (percentage >= 50) return Colors.blue;
  if (percentage >= 25) return Colors.orange;
  return Colors.red;
});

// Accessibility progress icon size provider
final accessibilityProgressIconSizeProvider = Provider<double>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return 24.0;
  if (percentage >= 50) return 22.0;
  if (percentage >= 25) return 20.0;
  return 18.0;
});

// Accessibility progress icon weight provider
final accessibilityProgressIconWeightProvider = Provider<FontWeight>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return FontWeight.bold;
  if (percentage >= 50) return FontWeight.w600;
  if (percentage >= 25) return FontWeight.w500;
  return FontWeight.normal;
});

// Accessibility progress icon style provider
final accessibilityProgressIconStyleProvider = Provider<IconStyle>((ref) {
  final percentage = ref.watch(accessibilityProgressPercentageProvider);
  if (percentage >= 75) return IconStyle.filled;
  if (percentage >= 50) return IconStyle.outlined;
  if (percentage >= 25) return IconStyle.outlined;
  return IconStyle.outlined;
});

enum IconStyle { filled, outlined }

extension IconStyleExtension on IconStyle {
  IconData getIcon(IconData filled, IconData outlined) {
    switch (this) {
      case IconStyle.filled:
        return filled;
      case IconStyle.outlined:
        return outlined;
    }
  }
}
