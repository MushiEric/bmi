import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bmi_controller.dart';
import '../themes/color.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart'; 
import '';

class ResultScreen extends StatelessWidget {
  final BMIController bmiController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              FadeInDown(child: _buildResultCard(isDarkMode)),
              SizedBox(height: 40.h),
              SlideInUp(child: _buildBMIRangeBar(isDarkMode)),
              SizedBox(height: 40.h),
              FadeInUp(child: _buildAdviceCard(isDarkMode)),
              SizedBox(height: 40.h),
              BounceInUp(child: _buildBackButton()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: CustomBackButton(),
      title: Text(
        "BMI Result".tr,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      backgroundColor: Colors.transparent,
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

  Widget _buildResultCard(bool isDarkMode) {
    return Obx(() => Card(
          elevation: 12,
          shadowColor: isDarkMode ? Colors.black26 : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(25.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey[850]!, Colors.grey[900]!]
                    : [Colors.white, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your BMI".tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white70 : AppColors.primary,
                  ),
                ),
                SizedBox(height: 15.h),
                ZoomIn(
                  child: Text(
                    bmiController.bmi.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(bmiController.status.value),
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  bmiController.status.value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(bmiController.status.value),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildBMIRangeBar(bool isDarkMode) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 30.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.underweight,
                    AppColors.normal,
                    AppColors.overweight,
                    AppColors.obese,
                  ],
                  stops: [0.25, 0.50, 0.75, 1.0],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            Positioned(
              left: _calculateBMIPosition(),
              child: Column(
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    size: 40.h,
                  ),
                  Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black87, width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRangeLabel("Underweight".tr, AppColors.underweight),
            _buildRangeLabel("Normal".tr, AppColors.normal),
            _buildRangeLabel("Overweight".tr, AppColors.overweight),
            _buildRangeLabel("Obese".tr, AppColors.obese),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAdviceCard(bool isDarkMode) {
    return Obx(() => Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Text(
                  "Health Advice".tr,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white70 : AppColors.primary,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  _getAdvice(bmiController.status.value),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ));
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "Underweight":
        return AppColors.underweight;
      case "Normal":
        return AppColors.normal;
      case "Overweight":
        return AppColors.overweight;
      case "Obese":
        return AppColors.obese;
      default:
        return Colors.grey;
    }
  }

  double _calculateBMIPosition() {
    double bmi = bmiController.bmi.value;
    double minBMI = 10, maxBMI = 40;
    double barWidth = Get.width - 40.w - 20.w; // Adjusted for padding and indicator size

    if (bmi < minBMI) bmi = minBMI;
    if (bmi > maxBMI) bmi = maxBMI;

    double position = (bmi - minBMI) / (maxBMI - minBMI) * barWidth;
    return position.clamp(0, barWidth - 10.w); // Ensure it stays within bounds
  }

  String _getAdvice(String status) {
    switch (status) {
      case "Underweight":
        return "You’re underweight. Consider a nutrient-rich diet with healthy fats and proteins. Consult a nutritionist for personalized guidance.";
      case "Normal":
        return "Great job! Your weight is healthy. Maintain it with a balanced diet and regular physical activity.";
      case "Overweight":
        return "You’re overweight. Try incorporating more exercise and a balanced diet. Small changes can make a big difference!";
      case "Obese":
        return "You’re in the obese range. Speak with a healthcare professional for a tailored plan to reach a healthier weight.";
      default:
        return "Calculate your BMI to get personalized advice.";
    }
  }
}