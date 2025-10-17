import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/accessibility_provider.dart';
import '../services/accessibility_service.dart';
import '../theme/app_colors.dart';

class AccessibilitySettings extends ConsumerWidget {
  const AccessibilitySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(allAccessibilitySettingsProvider);
              ref.refresh(accessibilityLevelProvider);
              ref.refresh(accessibilityRecommendationsProvider);
              ref.refresh(accessibilityStatisticsProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accessibility Overview
            _buildAccessibilityOverview(ref),
            const SizedBox(height: 20),

            // Font Scale
            _buildFontScaleSetting(ref),
            const SizedBox(height: 20),

            // Visual Settings
            _buildVisualSettings(ref),
            const SizedBox(height: 20),

            // Motion Settings
            _buildMotionSettings(ref),
            const SizedBox(height: 20),

            // Audio Settings
            _buildAudioSettings(ref),
            const SizedBox(height: 20),

            // Recommendations
            _buildRecommendations(ref),
            const SizedBox(height: 20),

            // Statistics
            _buildStatistics(ref),
            const SizedBox(height: 20),

            // Reset Button
            _buildResetButton(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityOverview(WidgetRef ref) {
    final levelAsync = ref.watch(accessibilityLevelProvider);
    final progressAsync = ref.watch(accessibilityProgressProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accessibility Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            levelAsync.when(
              data: (level) => Row(
                children: [
                  Icon(Icons.accessibility, color: level.color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: level.color,
                          ),
                        ),
                        Text(
                          level.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Progress'),
                    Text('${(progressAsync * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progressAsync,
                  backgroundColor: AppColors.lightGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressAsync >= 0.75
                        ? Colors.green
                        : progressAsync >= 0.5
                        ? Colors.blue
                        : progressAsync >= 0.25
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontScaleSetting(WidgetRef ref) {
    final fontScale = ref.watch(fontScaleProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Font Scale',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Small'),
                Expanded(
                  child: Slider(
                    value: fontScale,
                    min: 0.8,
                    max: 2.0,
                    divisions: 12,
                    label: fontScale.toStringAsFixed(1),
                    onChanged: (value) {
                      ref.read(fontScaleProvider.notifier).setFontScale(value);
                    },
                  ),
                ),
                const Text('Large'),
              ],
            ),
            Text(
              'Current scale: ${fontScale.toStringAsFixed(1)}x',
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualSettings(WidgetRef ref) {
    final highContrast = ref.watch(highContrastProvider);
    final largeText = ref.watch(largeTextProvider);
    final boldText = ref.watch(boldTextProvider);
    final colorBlind = ref.watch(colorBlindProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visual Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('High Contrast'),
              subtitle: const Text('Increase contrast for better visibility'),
              value: highContrast,
              onChanged: (value) {
                ref.read(highContrastProvider.notifier).setHighContrast(value);
              },
            ),
            SwitchListTile(
              title: const Text('Large Text'),
              subtitle: const Text('Use larger text throughout the app'),
              value: largeText,
              onChanged: (value) {
                ref.read(largeTextProvider.notifier).setLargeText(value);
              },
            ),
            SwitchListTile(
              title: const Text('Bold Text'),
              subtitle: const Text('Use bold text for better readability'),
              value: boldText,
              onChanged: (value) {
                ref.read(boldTextProvider.notifier).setBoldText(value);
              },
            ),
            SwitchListTile(
              title: const Text('Color Blind Support'),
              subtitle: const Text('Optimize colors for color blind users'),
              value: colorBlind,
              onChanged: (value) {
                ref.read(colorBlindProvider.notifier).setColorBlind(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotionSettings(WidgetRef ref) {
    final reduceMotion = ref.watch(reduceMotionProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Motion Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Reduce Motion'),
              subtitle: const Text('Minimize animations and transitions'),
              value: reduceMotion,
              onChanged: (value) {
                ref.read(reduceMotionProvider.notifier).setReduceMotion(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioSettings(WidgetRef ref) {
    final screenReader = ref.watch(screenReaderProvider);
    final voiceOver = ref.watch(voiceOverProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Audio Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Screen Reader'),
              subtitle: const Text('Enable screen reader support'),
              value: screenReader,
              onChanged: (value) {
                ref.read(screenReaderProvider.notifier).setScreenReader(value);
              },
            ),
            SwitchListTile(
              title: const Text('Voice Over'),
              subtitle: const Text('Enable voice over navigation'),
              value: voiceOver,
              onChanged: (value) {
                ref.read(voiceOverProvider.notifier).setVoiceOver(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(WidgetRef ref) {
    final recommendationsAsync = ref.watch(
      accessibilityRecommendationsProvider,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            recommendationsAsync.when(
              data: (recommendations) {
                if (recommendations.isEmpty) {
                  return const Text(
                    'Great! All accessibility features are optimized.',
                    style: TextStyle(fontSize: 14, color: AppColors.success),
                  );
                }
                return Column(
                  children: recommendations.map((recommendation) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(WidgetRef ref) {
    final statsAsync = ref.watch(accessibilityStatisticsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  _buildStatRow(
                    'Accessibility Level',
                    stats['level'] ?? 'None',
                  ),
                  _buildStatRow('Score', '${stats['score'] ?? 0}/8'),
                  _buildStatRow(
                    'Enabled Features',
                    '${stats['enabledFeatures'] ?? 0}',
                  ),
                  _buildStatRow(
                    'Total Features',
                    '${stats['totalFeatures'] ?? 8}',
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
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

  Widget _buildResetButton(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reset Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Reset all accessibility settings to their default values.',
              style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await AccessibilityService.resetToDefault();
                  ref.refresh(allAccessibilitySettingsProvider);
                  ref.refresh(accessibilityLevelProvider);
                  ref.refresh(accessibilityRecommendationsProvider);
                  ref.refresh(accessibilityStatisticsProvider);
                },
                child: const Text('Reset to Default'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
