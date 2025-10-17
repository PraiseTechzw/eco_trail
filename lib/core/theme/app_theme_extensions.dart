import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  const AppThemeExtensions({
    required this.forestGradient,
    required this.oceanGradient,
    required this.sunsetGradient,
    required this.earthGradient,
    required this.successLight,
    required this.warningLight,
    required this.errorLight,
    required this.infoLight,
    required this.cardElevation,
    required this.borderRadius,
    required this.spacing,
  });

  final List<Color> forestGradient;
  final List<Color> oceanGradient;
  final List<Color> sunsetGradient;
  final List<Color> earthGradient;
  final Color successLight;
  final Color warningLight;
  final Color errorLight;
  final Color infoLight;
  final double cardElevation;
  final double borderRadius;
  final double spacing;

  @override
  AppThemeExtensions copyWith({
    List<Color>? forestGradient,
    List<Color>? oceanGradient,
    List<Color>? sunsetGradient,
    List<Color>? earthGradient,
    Color? successLight,
    Color? warningLight,
    Color? errorLight,
    Color? infoLight,
    double? cardElevation,
    double? borderRadius,
    double? spacing,
  }) {
    return AppThemeExtensions(
      forestGradient: forestGradient ?? this.forestGradient,
      oceanGradient: oceanGradient ?? this.oceanGradient,
      sunsetGradient: sunsetGradient ?? this.sunsetGradient,
      earthGradient: earthGradient ?? this.earthGradient,
      successLight: successLight ?? this.successLight,
      warningLight: warningLight ?? this.warningLight,
      errorLight: errorLight ?? this.errorLight,
      infoLight: infoLight ?? this.infoLight,
      cardElevation: cardElevation ?? this.cardElevation,
      borderRadius: borderRadius ?? this.borderRadius,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  AppThemeExtensions lerp(ThemeExtension<AppThemeExtensions>? other, double t) {
    if (other is! AppThemeExtensions) {
      return this;
    }
    return AppThemeExtensions(
      forestGradient: _lerpColorList(forestGradient, other.forestGradient, t),
      oceanGradient: _lerpColorList(oceanGradient, other.oceanGradient, t),
      sunsetGradient: _lerpColorList(sunsetGradient, other.sunsetGradient, t),
      earthGradient: _lerpColorList(earthGradient, other.earthGradient, t),
      successLight:
          Color.lerp(successLight, other.successLight, t) ?? successLight,
      warningLight:
          Color.lerp(warningLight, other.warningLight, t) ?? warningLight,
      errorLight: Color.lerp(errorLight, other.errorLight, t) ?? errorLight,
      infoLight: Color.lerp(infoLight, other.infoLight, t) ?? infoLight,
      cardElevation: cardElevation,
      borderRadius: borderRadius,
      spacing: spacing,
    );
  }

  List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) return a;
    return List.generate(a.length, (index) {
      return Color.lerp(a[index], b[index], t) ?? a[index];
    });
  }

  static const AppThemeExtensions light = AppThemeExtensions(
    forestGradient: AppColors.forestGradient,
    oceanGradient: AppColors.oceanGradient,
    sunsetGradient: AppColors.sunsetGradient,
    earthGradient: AppColors.earthGradient,
    successLight: AppColors.successLight,
    warningLight: AppColors.warningLight,
    errorLight: AppColors.errorLight,
    infoLight: AppColors.infoLight,
    cardElevation: 2.0,
    borderRadius: 12.0,
    spacing: 16.0,
  );

  static const AppThemeExtensions dark = AppThemeExtensions(
    forestGradient: AppColors.forestGradient,
    oceanGradient: AppColors.oceanGradient,
    sunsetGradient: AppColors.sunsetGradient,
    earthGradient: AppColors.earthGradient,
    successLight: AppColors.successLight,
    warningLight: AppColors.warningLight,
    errorLight: AppColors.errorLight,
    infoLight: AppColors.infoLight,
    cardElevation: 4.0,
    borderRadius: 12.0,
    spacing: 16.0,
  );
}

extension AppThemeExtensionsExtension on ThemeData {
  AppThemeExtensions get appExtensions => extension<AppThemeExtensions>()!;
}
