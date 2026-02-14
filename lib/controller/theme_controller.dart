import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // Storage key for theme preference
  static const String _storageKey = 'is_dark_mode';

  // Reactive state for dark mode
  final _isDarkMode = false.obs;

  // Getter for dark mode state
  bool get isDarkMode => _isDarkMode.value;

  // Getter for ThemeMode
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // Storage instance
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Load saved theme preference from storage
  void _loadThemeFromStorage() {
    final savedTheme = _storage.read<bool>(_storageKey);
    if (savedTheme != null) {
      _isDarkMode.value = savedTheme;
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToStorage();
  }

  /// Set specific theme
  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    _saveThemeToStorage();
  }

  /// Save theme preference to storage
  void _saveThemeToStorage() {
    _storage.write(_storageKey, _isDarkMode.value);
  }
}
