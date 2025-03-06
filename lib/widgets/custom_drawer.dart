import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../themes/color.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/language_controller.dart';
import '../controllers/bmi_controller.dart';
import '../services/rate_us _service.dart';
import 'package:animate_do/animate_do.dart'; // Add for animations
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatelessWidget {
  final LanguageController languageController = Get.find();
  final BMIController bmiController = Get.find();
  final ThemeController themeController = Get.find();

  void _shareBMI() async {
    String message =
        "Check out my BMI result! Calculate yours with this BMI Calculator App: https://yourapp.link";
    try {
      await Share.share(message);
    } catch (e) {
      print("Sharing failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.isDarkMode.value;

    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          SizedBox(height: 10.h),
          _buildDrawerItem(
            icon: Icons.history,
            text: "BMI History".tr,
            onTap: () => Get.toNamed('/history'),
            index: 0,
          ),
          _buildDrawerItem(
            icon: Icons.lightbulb,
            text: "Health Tips".tr,
            onTap: () => Get.toNamed('/tips'),
            index: 1,
          ),
          _buildDrawerItem(
            icon: Icons.share,
            text: "Share App".tr,
            onTap: _shareBMI,
            index: 2,
          ),
          _buildDrawerItem(
            icon: Icons.privacy_tip,
            text: "Privacy Policy".tr,
            onTap: () => Get.toNamed("/policy"),
            index: 3,
          ),
          _buildDrawerItem(
            icon: Icons.star_rate,
            text: "Rate Us".tr,
            onTap: () => RateUsService.requestReview(),
            index: 4,
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300], height: 20.h),
          _buildLanguageSection(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FadeInDown(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BMI App".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 15.h),
            Obx(() => SwitchListTile(
                  title: Text(
                    themeController.isDarkMode.value ? "Light Mode".tr : "Dark Mode".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  activeColor: AppColors.secondary,
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.grey[400],
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.toggleTheme(),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required int index,
  }) {
    return SlideInLeft(
      duration: Duration(milliseconds: 300 + (index * 100)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 24.sp),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
          ),
        ),
        onTap: onTap,
        tileColor: themeController.isDarkMode.value ? Colors.grey[850] : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hoverColor: AppColors.primary.withOpacity(0.1),
        splashColor: AppColors.primary.withOpacity(0.2),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            child: Text(
              "Language".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value ? Colors.white : AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() => RadioListTile(
                title: Text(
                  "English 🇬🇧",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: themeController.isDarkMode.value ? Colors.white70 : Colors.black87,
                  ),
                ),
                value: "en",
                groupValue: languageController.currentLocale.value.languageCode,
                onChanged: (value) => languageController.changeLanguage(value.toString()),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                dense: true,
              )),
          Obx(() => RadioListTile(
                title: Text(
                  "Swahili 🇹🇿",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: themeController.isDarkMode.value ? Colors.white70 : Colors.black87,
                  ),
                ),
                value: "sw",
                groupValue: languageController.currentLocale.value.languageCode,
                onChanged: (value) => languageController.changeLanguage(value.toString()),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                dense: true,
              )),
        ],
      ),
    );
  }
}