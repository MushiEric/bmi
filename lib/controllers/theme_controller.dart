import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage _box = GetStorage();
  var isDarkMode = false.obs; // Observes dark mode state

  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme when the controller initializes
  }

  void _loadTheme() {
    // Check if the user has manually set a theme preference
    if (_box.hasData("isDarkMode")) {
      isDarkMode.value = _box.read("isDarkMode");
    } else {
      // If no preference, follow system theme
      isDarkMode.value = Get.isPlatformDarkMode;
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write("isDarkMode", isDarkMode.value); // Save user preference
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
