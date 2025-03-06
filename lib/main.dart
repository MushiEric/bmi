import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'localization/app_translations.dart';
import 'bindings/theme_binding.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/theme_controller.dart';
import './screens/splash_screen.dart';
import 'bindings/bmi_binding.dart';
import 'controllers/language_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/onbording_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); 
  Get.put(LanguageController()); 
  ThemeBinding().dependencies(); 

  final GetStorage _storage = GetStorage();
  bool seenOnboarding = _storage.read("seenOnboarding") ?? false;


  runApp(MyApp(startScreen: seenOnboarding ? SplashScreen() : OnboardingScreen()));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
    MyApp({required this.startScreen});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), 
      minTextAdapt: true,
      splitScreenMode: true, 
      builder: (context, child) {
        return Obx(() => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'BMI App',
              darkTheme: ThemeData.dark(),
              theme: ThemeData.light(),
              themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.system,
              home: SplashScreen(),
              getPages: AppRoutes.routes,
              initialBinding: BMIBinding(),
              translations: AppTranslations(),
              fallbackLocale: Locale("en"),
              locale: const  Locale("en"),
            ));
      },
    );
  }
}
