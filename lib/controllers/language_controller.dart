import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:ui';

class LanguageController extends GetxController {
  final box = GetStorage(); // ✅ Initialize GetStorage
  var currentLocale = Locale('en').obs; // Default to English

  @override
  void onInit() {
    _loadSavedLanguage(); // ✅ Load saved language on app start
    super.onInit();
  }

  void changeLanguage(String languageCode) {
    Locale locale = Locale(languageCode);
    currentLocale.value = locale;
    Get.updateLocale(locale);
    box.write('selected_language', languageCode); // ✅ Save language in storage
  }

  void _loadSavedLanguage() {
    String? savedLanguage = box.read('selected_language');
    if (savedLanguage != null) {
      currentLocale.value = Locale(savedLanguage);
      Get.updateLocale(currentLocale.value);
    }
  }
}
