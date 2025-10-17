import 'package:flutter/material.dart';
import 'app_colors.dart';

class GradientDecorations {
  static BoxDecoration forestGradient({
    double borderRadius = 12.0,
    List<Color>? colors,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ?? AppColors.forestGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static BoxDecoration oceanGradient({
    double borderRadius = 12.0,
    List<Color>? colors,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ?? AppColors.oceanGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static BoxDecoration sunsetGradient({
    double borderRadius = 12.0,
    List<Color>? colors,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ?? AppColors.sunsetGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static BoxDecoration earthGradient({
    double borderRadius = 12.0,
    List<Color>? colors,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ?? AppColors.earthGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static BoxDecoration cardGradient({
    required List<Color> colors,
    double borderRadius = 12.0,
    double elevation = 2.0,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      ],
    );
  }

  static BoxDecoration statusGradient({
    required Color statusColor,
    double borderRadius = 8.0,
    bool isLight = false,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isLight
            ? [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)]
            : [statusColor, statusColor.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
    );
  }
}
