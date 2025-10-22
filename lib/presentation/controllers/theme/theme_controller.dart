import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable untuk dark mode
  final _isDarkMode = true.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    print('ThemeController initialized');
    // Load saved theme preference (optional)
    // _loadThemePreference();
  }

  @override
  void onClose() {
    print('ThemeController disposed');
    super.onClose();
  }

  // Toggle theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;

    // Update GetX theme
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // Save preference (optional)
    // _saveThemePreference();

    Get.snackbar(
      'Theme Changed',
      _isDarkMode.value ? 'Dark mode activated' : 'Light mode activated',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: _isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
      colorText: _isDarkMode.value ? Colors.white : Colors.black,
    );
  }

  // Get current theme data
  ThemeData get currentTheme {
    return _isDarkMode.value ? darkTheme : lightTheme;
  }

  // Dark Theme
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Color(0xFF121212),
      cardColor: Color(0xFF1E1E1E),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1C1C19),
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }

  // Light Theme
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  // Optional: Save theme preference to storage
  // Future<void> _saveThemePreference() async {
  //   final storage = Get.find<LocalStorageService>();
  //   await storage.setBool('isDarkMode', _isDarkMode.value);
  // }

  // Optional: Load theme preference from storage
  // Future<void> _loadThemePreference() async {
  //   final storage = Get.find<LocalStorageService>();
  //   _isDarkMode.value = storage.getBool('isDarkMode') ?? true;
  // }
}
