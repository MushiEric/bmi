import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/color.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart'; // For animations

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: _buildHeader(isDarkMode),
              ),
              SizedBox(height: 25.h),
              _buildSection(
                title: "🔒 Our Commitment",
                content: "At BMI Calculator, your privacy is our priority. We are committed to ensuring your data stays secure and private. This policy outlines how we handle your information—or rather, how we don’t.",
                isDarkMode: isDarkMode,
                index: 0,
              ),
              _buildSection(
                title: "📊 Data Collection",
                content: "We do not collect, store, or process any personal data. All BMI calculations are performed locally on your device. Your height, weight, and results never leave your phone.",
                isDarkMode: isDarkMode,
                index: 1,
              ),
              _buildSection(
                title: "🌐 Third-Party Services",
                content: "This app does not integrate third-party tracking, analytics, or advertising services. No data is shared externally, ensuring complete privacy.",
                isDarkMode: isDarkMode,
                index: 2,
              ),
              _buildSection(
                title: "📱 App Permissions",
                content: "We only request permissions necessary for core functionality (e.g., storage for BMI history, if applicable). No unnecessary access is sought.",
                isDarkMode: isDarkMode,
                index: 3,
              ),
              _buildSection(
                title: "✉️ Contact Us",
                content: "Have questions or concerns? Reach out to us at support@bmiapp.com. We’re here to help!",
                isDarkMode: isDarkMode,
                index: 4,
              ),
              SizedBox(height: 40.h),
              FadeInUp(
                child: Center(
                  child: _buildBackButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: CustomBackButton(color: AppColors.white),
      title: Text(
        "Privacy Policy".tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      backgroundColor: Theme.of(Get.context!).brightness == Brightness.dark
          ? Colors.grey[850]
          : AppColors.primary,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Text(
      "Your Privacy Matters".tr,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : AppColors.primary,
        shadows: [
          Shadow(
            color: isDarkMode ? Colors.black26 : Colors.grey[300]!,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required bool isDarkMode,
    required int index, // Added index parameter
  }) {
    return SlideInUp(
      duration: Duration(milliseconds: 400 + (index * 150)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title.split(' ')[0], // Emoji
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title.split(' ').sublist(1).join(' '), // Title without emoji
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black26 : Colors.grey[200]!,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return ElevatedButton(
      onPressed: () => Get.back(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black38,
      ),
      child: Text(
        "Go Back".tr,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}