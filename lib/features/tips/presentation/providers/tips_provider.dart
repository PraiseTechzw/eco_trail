import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/sustainability_service.dart';
import '../../data/models/sustainability_tip.dart';

// Sustainability tips provider
final sustainabilityTipsProvider = StreamProvider<List<SustainabilityTip>>((
  ref,
) {
  return SustainabilityService.getSustainabilityTipsStream();
});

// Selected tip provider
final selectedTipProvider = StateProvider<SustainabilityTip?>((ref) => null);

// Search query provider
final tipsSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter category provider
final tipsFilterCategoryProvider = StateProvider<String?>((ref) => null);

// Filtered tips provider
final filteredTipsProvider = FutureProvider<List<SustainabilityTip>>((
  ref,
) async {
  final searchQuery = ref.watch(tipsSearchQueryProvider);
  final filterCategory = ref.watch(tipsFilterCategoryProvider);

  if (searchQuery.isNotEmpty) {
    return SustainabilityService.searchTips(searchQuery);
  } else if (filterCategory != null) {
    return SustainabilityService.getTipsByCategory(filterCategory);
  } else {
    // Return all tips
    final tips =
        await SustainabilityService.getSustainabilityTipsStream().first;
    return tips;
  }
});

// Tip categories provider
final tipCategoriesProvider = Provider<List<String>>((ref) {
  return SustainabilityService.getTipCategories();
});

// Carbon activities provider
final carbonActivitiesProvider =
    StreamProvider.family<List<CarbonActivity>, String>((ref, userId) {
      return SustainabilityService.getUserCarbonActivities(userId);
    });

// Carbon footprint summary provider
final carbonFootprintProvider =
    StreamProvider.family<CarbonFootprintSummary, String>((ref, userId) {
      return SustainabilityService.getCarbonFootprintStream(userId);
    });

// Transport types provider
final transportTypesProvider = Provider<List<String>>((ref) {
  return SustainabilityService.getTransportTypes();
});

// Energy types provider
final energyTypesProvider = Provider<List<String>>((ref) {
  return SustainabilityService.getEnergyTypes();
});

// Food types provider
final foodTypesProvider = Provider<List<String>>((ref) {
  return SustainabilityService.getFoodTypes();
});

// Helper function to get difficulty color

Color getDifficultyColor(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return AppColors.success;
    case 'medium':
      return AppColors.warning;
    case 'hard':
      return AppColors.error;
    default:
      return AppColors.mediumGray;
  }
}

// Helper function to get impact level
String getImpactLevel(int impact) {
  if (impact >= 50) {
    return 'High Impact';
  } else if (impact >= 20) {
    return 'Medium Impact';
  } else if (impact >= 5) {
    return 'Low Impact';
  } else {
    return 'Minimal Impact';
  }
}

// Helper function to get impact color
Color getImpactColor(int impact) {
  if (impact >= 50) {
    return AppColors.success;
  } else if (impact >= 20) {
    return AppColors.warning;
  } else if (impact >= 5) {
    return AppColors.info;
  } else {
    return AppColors.mediumGray;
  }
}

// Helper function to format emissions
String formatEmissions(double emissions) {
  if (emissions >= 1000) {
    return '${(emissions / 1000).toStringAsFixed(1)}t CO₂';
  } else {
    return '${emissions.toStringAsFixed(1)}kg CO₂';
  }
}

// Helper function to get emissions trend
String getEmissionsTrend(double current, double previous) {
  if (previous == 0) return 'New';

  final change = ((current - previous) / previous) * 100;

  if (change > 10) {
    return '↗️ +${change.toStringAsFixed(1)}%';
  } else if (change < -10) {
    return '↘️ ${change.toStringAsFixed(1)}%';
  } else {
    return '→ ${change.toStringAsFixed(1)}%';
  }
}

// Helper function to get category icon
IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'transportation':
      return Icons.directions_car;
    case 'energy':
      return Icons.flash_on;
    case 'food':
      return Icons.restaurant;
    case 'waste':
      return Icons.delete;
    case 'water':
      return Icons.water_drop;
    case 'shopping':
      return Icons.shopping_bag;
    case 'travel':
      return Icons.flight;
    case 'home':
      return Icons.home;
    default:
      return Icons.eco;
  }
}

// Helper function to get category color
Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'transportation':
      return AppColors.primaryGreen;
    case 'energy':
      return Colors.orange;
    case 'food':
      return Colors.brown;
    case 'waste':
      return Colors.grey;
    case 'water':
      return Colors.blue;
    case 'shopping':
      return Colors.purple;
    case 'travel':
      return Colors.cyan;
    case 'home':
      return Colors.green;
    default:
      return AppColors.mediumGray;
  }
}
