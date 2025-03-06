import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../themes/color.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipsScreen extends StatelessWidget {
  final List<Map<String, String>> tips = [
    {
      "title": "🏃 Stay Active",
      "desc": "Exercise at least 30 minutes a day to keep your body fit and healthy.",
      "more": "Try activities like jogging, cycling, swimming, or home workouts."
    },
    {
      "title": "🥦 Eat Healthy",
      "desc": "Include fruits, veggies, and proteins in your diet to stay strong.",
      "more": "Avoid processed foods and focus on balanced nutrition."
    },
    {
      "title": "💧 Stay Hydrated",
      "desc": "Drink at least 8 cups of water daily for optimal body functions.",
      "more": "Limit sugary drinks and drink more fresh water throughout the day."
    },
    {
      "title": "😴 Get Enough Sleep",
      "desc": "Ensure 7-9 hours of quality sleep to recharge your body and mind.",
      "more": "Avoid screens before bedtime and create a relaxing sleep routine."
    },
    {
      "title": "🧘 Manage Stress",
      "desc": "Practice relaxation techniques like meditation and deep breathing.",
      "more": "Engage in hobbies, listen to music, or talk to a friend."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            FadeInDown(
              child: Text(
                "Your Wellness Guide".tr,
                style: TextStyle(
                  fontSize: 22.sp,
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
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return SlideInUp(
                    duration: Duration(milliseconds: 400 + (index * 150)),
                    child: _buildTipCard(tips[index], isDarkMode),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: CustomBackButton(),
      title: Text(
        "Health & Wellness Tips".tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
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

  Widget _buildTipCard(Map<String, String> tip, bool isDarkMode) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            tip['title']!.split(' ')[0], // Emoji
            style: TextStyle(fontSize: 24.sp),
          ),
        ),
        title: Text(
          tip['title']!.split(' ').sublist(1).join(' '), // Title without emoji
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Text(
            tip['desc']!,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Text(
              tip['more']!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : AppColors.secondary,
                height: 1.5,
              ),
            ),
          ),
        ],
        tilePadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        collapsedIconColor: AppColors.primary,
        iconColor: AppColors.primary,
      ),
    );
  }
}