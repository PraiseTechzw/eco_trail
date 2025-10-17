import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';

  static SharedPreferences? _prefs;
  static Locale _currentLocale = const Locale('en', 'US');

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English (United States)
    Locale('es', 'ES'), // Spanish (Spain)
    Locale('fr', 'FR'), // French (France)
    Locale('de', 'DE'), // German (Germany)
    Locale('it', 'IT'), // Italian (Italy)
    Locale('pt', 'BR'), // Portuguese (Brazil)
    Locale('ja', 'JP'), // Japanese (Japan)
    Locale('ko', 'KR'), // Korean (South Korea)
    Locale('zh', 'CN'), // Chinese (China)
    Locale('ar', 'SA'), // Arabic (Saudi Arabia)
  ];

  // Language names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ja': '日本語',
    'ko': '한국어',
    'zh': '中文',
    'ar': 'العربية',
  };

  // Country names
  static const Map<String, String> countryNames = {
    'US': 'United States',
    'ES': 'Spain',
    'FR': 'France',
    'DE': 'Germany',
    'IT': 'Italy',
    'BR': 'Brazil',
    'JP': 'Japan',
    'KR': 'South Korea',
    'CN': 'China',
    'SA': 'Saudi Arabia',
  };

  // Initialize localization service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLocale();
  }

  // Load saved locale
  static Future<void> _loadSavedLocale() async {
    if (_prefs == null) await initialize();

    final languageCode = _prefs!.getString(_languageKey) ?? 'en';
    final countryCode = _prefs!.getString(_countryKey) ?? 'US';

    _currentLocale = Locale(languageCode, countryCode);
  }

  // Get current locale
  static Locale getCurrentLocale() {
    return _currentLocale;
  }

  // Set locale
  static Future<void> setLocale(Locale locale) async {
    if (_prefs == null) await initialize();

    _currentLocale = locale;
    await _prefs!.setString(_languageKey, locale.languageCode);
    await _prefs!.setString(_countryKey, locale.countryCode ?? '');
  }

  // Get language name
  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }

  // Get country name
  static String getCountryName(String countryCode) {
    return countryNames[countryCode] ?? countryCode;
  }

  // Get full language name with country
  static String getFullLanguageName(Locale locale) {
    final languageName = getLanguageName(locale.languageCode);
    final countryName = getCountryName(locale.countryCode ?? '');
    return '$languageName ($countryName)';
  }

  // Check if locale is supported
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode,
    );
  }

  // Get supported locales for language
  static List<Locale> getSupportedLocalesForLanguage(String languageCode) {
    return supportedLocales
        .where((locale) => locale.languageCode == languageCode)
        .toList();
  }

  // Get all supported languages
  static List<String> getSupportedLanguages() {
    return supportedLocales
        .map((locale) => locale.languageCode)
        .toSet()
        .toList();
  }

  // Get all supported countries
  static List<String> getSupportedCountries() {
    return supportedLocales
        .map((locale) => locale.countryCode ?? '')
        .where((country) => country.isNotEmpty)
        .toSet()
        .toList();
  }

  // Get locale from language and country codes
  static Locale getLocaleFromCodes(String languageCode, String countryCode) {
    return Locale(languageCode, countryCode);
  }

  // Get locale from string
  static Locale getLocaleFromString(String localeString) {
    final parts = localeString.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return const Locale('en', 'US');
  }

  // Get string from locale
  static String getStringFromLocale(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  // Get default locale
  static Locale getDefaultLocale() {
    return const Locale('en', 'US');
  }

  // Get system locale
  static Locale getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (isLocaleSupported(systemLocale)) {
      return systemLocale;
    }

    // Try to find a supported locale with the same language
    final supportedLocale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == systemLocale.languageCode,
      orElse: () => getDefaultLocale(),
    );

    return supportedLocale;
  }

  // Get locale display name
  static String getLocaleDisplayName(Locale locale) {
    final languageName = getLanguageName(locale.languageCode);
    final countryName = getCountryName(locale.countryCode ?? '');

    if (countryName.isNotEmpty) {
      return '$languageName ($countryName)';
    }
    return languageName;
  }

  // Get locale flag emoji
  static String getLocaleFlag(Locale locale) {
    const flagMap = {
      'US': '🇺🇸',
      'ES': '🇪🇸',
      'FR': '🇫🇷',
      'DE': '🇩🇪',
      'IT': '🇮🇹',
      'BR': '🇧🇷',
      'JP': '🇯🇵',
      'KR': '🇰🇷',
      'CN': '🇨🇳',
      'SA': '🇸🇦',
    };

    return flagMap[locale.countryCode] ?? '🌍';
  }

  // Get locale info
  static Map<String, dynamic> getLocaleInfo(Locale locale) {
    return {
      'locale': locale,
      'languageCode': locale.languageCode,
      'countryCode': locale.countryCode,
      'languageName': getLanguageName(locale.languageCode),
      'countryName': getCountryName(locale.countryCode ?? ''),
      'displayName': getLocaleDisplayName(locale),
      'flag': getLocaleFlag(locale),
      'isSupported': isLocaleSupported(locale),
    };
  }

  // Get all locale info
  static List<Map<String, dynamic>> getAllLocaleInfo() {
    return supportedLocales.map((locale) => getLocaleInfo(locale)).toList();
  }

  // Get locales grouped by language
  static Map<String, List<Locale>> getLocalesGroupedByLanguage() {
    final Map<String, List<Locale>> grouped = {};

    for (final locale in supportedLocales) {
      final language = locale.languageCode;
      if (!grouped.containsKey(language)) {
        grouped[language] = [];
      }
      grouped[language]!.add(locale);
    }

    return grouped;
  }

  // Get locales grouped by country
  static Map<String, List<Locale>> getLocalesGroupedByCountry() {
    final Map<String, List<Locale>> grouped = {};

    for (final locale in supportedLocales) {
      final country = locale.countryCode ?? 'Unknown';
      if (!grouped.containsKey(country)) {
        grouped[country] = [];
      }
      grouped[country]!.add(locale);
    }

    return grouped;
  }
}
