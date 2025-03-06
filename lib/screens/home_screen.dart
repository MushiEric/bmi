import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bmi_controller.dart';
import '../widgets/custom_drawer.dart';
import '../themes/color.dart';
import '../controllers/theme_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart'; // Add this package for animations

class HomeScreen extends StatelessWidget {
  final BMIController bmiController = Get.find();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: FadeInUp(
            duration: Duration(milliseconds: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDarkMode),
                SizedBox(height: 25.h),
                _buildInputCard("Height".tr, _buildHeightInput(), isDarkMode),
                _buildErrorText(bmiController.heightError),
                SizedBox(height: 25.h),
                _buildInputCard("Weight".tr, _buildWeightInput(), isDarkMode),
                _buildErrorText(bmiController.weightError),
                SizedBox(height: 40.h),
                _buildCalculateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey[850] 
          : AppColors.primary,
      elevation: 0,
      title: Text(
        "BMI Calculator".tr,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => bmiController.clearFields(),
          icon: Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Reset',
        ),
      ],
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
    return ZoomIn(
      child: Text(
        "Calculate Your BMI".tr,
        style: TextStyle(
          fontSize: 28.sp,
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
    );
  }

  Widget _buildInputCard(String title, Widget child, bool isDarkMode) {
    return SlideInLeft(
      child: Card(
        elevation: 8,
        shadowColor: isDarkMode ? Colors.black26 : Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : AppColors.primary,
                ),
              ),
              SizedBox(height: 10.h),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeightInput() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(bmiController.heightController, "Enter Height".tr),
        ),
        SizedBox(width: 15.w),
        _buildDropdown(bmiController.heightUnit, ["cm".tr, "feet".tr, "inches".tr]),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(bmiController.weightController, "Enter Weight".tr),
        ),
        SizedBox(width: 15.w),
        _buildDropdown(bmiController.weightUnit, ["kg".tr, "lbs".tr]),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    bool isDarkMode = Theme.of(Get.context!).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => bmiController.validateInput(),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
    );
  }

  Widget _buildDropdown(RxString selectedValue, List<String> items) {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<String>(
            value: selectedValue.value,
            dropdownColor: Theme.of(Get.context!).cardColor,
            style: TextStyle(
              color: Theme.of(Get.context!).textTheme.bodyLarge!.color,
              fontSize: 16.sp,
            ),
            onChanged: (newValue) {
              selectedValue.value = newValue!;
              bmiController.validateInput();
            },
            items: items.map((unit) => DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            )).toList(),
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ),
        ));
  }

  Widget _buildErrorText(RxString error) {
    return Obx(() => error.value.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: SlideInUp(
              child: Text(
                error.value,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        : SizedBox());
  }

  Widget _buildCalculateButton() {
    return Center(
      child: Obx(() => BounceInUp(
            child: ElevatedButton(
              onPressed: bmiController.isValid.value ? bmiController.calculateBMI : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: bmiController.isValid.value 
                    ? AppColors.primary 
                    : Colors.grey[400],
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.black38,
              ),
              child: Text(
                "CALCULATE BMI".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          )),
    );
  }
}