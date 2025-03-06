import 'package:get/get.dart';
import '../screens/home_screen.dart';
import '../screens/result_screen.dart';
import '../bindings/bmi_binding.dart';
import '../screens/history_screen.dart';
import '../screens/tips_screen.dart';
import '../screens/privacy_policy_screen.dart';

class AppRoutes {
  static const HOME = '/';
  static const RESULT = '/result';

  static final routes = [
    GetPage(name: HOME, page: () => HomeScreen(),transition: Transition.fadeIn, binding: BMIBinding()),
    GetPage(name: RESULT, page: () => ResultScreen(),transition: Transition.fade),
    GetPage(name: '/history', page: () => HistoryScreen(), transition: Transition.rightToLeft),
    GetPage(name: '/tips', page: () => TipsScreen(), transition: Transition.rightToLeft),
    GetPage(name: "/policy", page: ()=>PrivacyPolicyScreen(),transition: Transition.circularReveal)

  ];
}




