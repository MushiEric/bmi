import 'package:bmi/screens/bmi_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../db/bmi_db_helper.dart';
import '../themes/color.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/bmi_controller.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final BMIDBHelper dbHelper = BMIDBHelper();
  String filterStatus = "All";

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(isDarkMode),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          FadeInDown(child: _buildFilterDropdown(isDarkMode)),
          SizedBox(height: 20.h),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getBMIHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: FadeInUp(
                      child: Text(
                        "No history available.".tr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  );
                }

                var filteredData = snapshot.data!;
                if (filterStatus != "All") {
                  filteredData = filteredData.where((item) => item['status'] == filterStatus).toList();
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var item = filteredData[index];
                    return SlideInUp(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      child: _buildHistoryCard(item, isDarkMode),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(isDarkMode),
    );
  }

  AppBar _buildAppBar(bool isDarkMode) {
    return AppBar(
      leading: CustomBackButton(),
      title: Text(
        "BMI History".tr,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : AppColors.primary,
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

  Widget _buildFilterDropdown(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.grey[200]!,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: DropdownButton<String>(
          value: filterStatus,
          isExpanded: true,
          dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
          style: TextStyle(
            fontSize: 16.sp,
            color: isDarkMode ? Colors.white : AppColors.primary,
          ),
          underline: SizedBox(),
          icon: Icon(Icons.filter_list, color: AppColors.primary),
          onChanged: (String? newValue) {
            setState(() {
              filterStatus = newValue!;
            });
          },
          items: ["All", "Underweight", "Normal", "Overweight", "Obese"].map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, bool isDarkMode) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(item['status']).withOpacity(0.1),
          child: Icon(Icons.fitness_center, color: _getStatusColor(item['status']), size: 24.sp),
        ),
        title: Text(
          "BMI: ${item['bmi'].toStringAsFixed(1)}",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : AppColors.text,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Text(
              "Status: ${item['status']}",
              style: TextStyle(
                fontSize: 16.sp,
                color: _getStatusColor(item['status']),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              _formatDate(item['date']),
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _deleteItem(item['id']),
        ),
      ),
    );
  }

  Widget _buildFAB(bool isDarkMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.bar_chart, color: Colors.white),
          onPressed: () => Get.to(() => BMIChartScreen()),
          tooltip: "View Chart".tr,
          heroTag: "chart",
        ),
        SizedBox(height: 10.h),
        FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.delete, color: Colors.white),
          onPressed: _clearHistory,
          tooltip: "Clear History".tr,
          heroTag: "delete",
        ),
      ],
    );
  }

  void _deleteItem(int id) {
    Get.defaultDialog(
      title: "Delete Entry".tr,
      middleText: "Are you sure you want to delete this entry?".tr,
      textConfirm: "Yes".tr,
      textCancel: "No".tr,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () async {
        await dbHelper.clearHistory();
        setState(() {});
        Get.back();
        Fluttertoast.showToast(
          msg: "Entry Deleted".tr,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
      },
    );
  }

  void _clearHistory() {
    Get.defaultDialog(
      title: "Clear History".tr,
      middleText: "Are you sure you want to delete all history?".tr,
      textConfirm: "Yes".tr,
      textCancel: "No".tr,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () async {
        await dbHelper.clearHistory();
        setState(() {});
        Get.back();
        Fluttertoast.showToast(
          msg: "History Cleared".tr,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
      },
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat.yMMMd().add_jm().format(parsedDate); // e.g., "Mar 4, 2025 3:00 PM"
    } catch (e) {
      return date;
    }
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
}