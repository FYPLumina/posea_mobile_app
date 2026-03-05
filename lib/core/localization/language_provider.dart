import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:posea_mobile_app/core/utils/constants.dart';

class AppLanguageOption {
  final String code;
  final String name;

  const AppLanguageOption({required this.code, required this.name});
}

// LanguageProvider manages the application's language settings. 
//It loads the saved language preference from secure storage on initialization, provides a method to change the language, and notifies listeners of any changes. 
//It also defines the supported languages and their corresponding locale codes.
class LanguageProvider extends ChangeNotifier {
  static const List<AppLanguageOption> supportedLanguages = [
    AppLanguageOption(code: 'en', name: 'English'),
    AppLanguageOption(code: 'si', name: 'සිංහල'),
  ];

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

// The current locale of the application, initialized to English by default.
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

// A list of supported locales derived from the supported language options, used for localization purposes in the app.
  List<Locale> get supportedLocales =>
      supportedLanguages.map((language) => Locale(language.code)).toList();

  LanguageProvider() {
    _loadSavedLanguage();
  }

// Loads the saved language preference from secure storage. 
//If a valid saved language code is found, it updates the current locale.
  Future<void> _loadSavedLanguage() async {
    final savedCode = await _storage.read(key: AppConstants.prefsKeyLanguage);
    if (savedCode != null && _isSupportedLanguage(savedCode)) {
      _locale = Locale(savedCode);
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (!_isSupportedLanguage(code) || code == _locale.languageCode) {
      return;
    }
    _locale = Locale(code);
    await _storage.write(key: AppConstants.prefsKeyLanguage, value: code);
    notifyListeners();
  }

  bool _isSupportedLanguage(String code) {
    return supportedLanguages.any((language) => language.code == code);
  }
}
