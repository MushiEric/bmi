import 'package:bmi/themes/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/bmi_db_helper.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart'; // For animations
import 'package:intl/intl.dart'; // For date formatting

class BMIChartScreen extends StatelessWidget {
  final BMIDBHelper dbHelper = BMIDBHelper();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(isDarkMode),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Text(
                "Your BMI Trend".tr,
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
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dbHelper.getBMIHistory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: FadeInUp(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history_toggle_off,
                              size: 60.sp,
                              color: isDarkMode ? Colors.white54 : Colors.grey[400],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "No history available.".tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  List<FlSpot> bmiSpots = snapshot.data!
                      .asMap()
                      .entries
                      .map((entry) => FlSpot(entry.key.toDouble(), entry.value['bmi']))
                      .toList();

                  return FadeInUp(
                    child: _buildChart(bmiSpots, snapshot.data!, isDarkMode),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDarkMode) {
    return AppBar(
      leading: CustomBackButton(),
      title: Text(
        "BMI Insights".tr,
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

  Widget _buildChart(List<FlSpot> bmiSpots, List<Map<String, dynamic>> data, bool isDarkMode) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                // color: isDarkMode ? Colors.white12 : Colors.grey[200],
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40.h,
                  interval: data.length > 10 ? 2 : 1, // Adjust based on data size
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      String date = _formatDate(data[index]['date']);
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40.w,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: isDarkMode ? Colors.white12 : Colors.grey[300]!,
                width: 1,
              ),
            ),
            minY: 10,
            maxY: 40,
            lineBarsData: [
              LineChartBarData(
                spots: bmiSpots,
                isCurved: true,
                color: AppColors.primary,
                barWidth: 4,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                // tooltipBgColor: isDarkMode ? Colors.grey[800] : Colors.white,
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    return LineTooltipItem(
                      "BMI: ${spot.y.toStringAsFixed(1)}\n${_formatDate(data[index]['date'])}",
                      TextStyle(
                        color: isDarkMode ? Colors.white : AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('MMM d').format(parsedDate); // e.g., "Mar 4"
    } catch (e) {
      return date.split(" ")[0];
    }
  }
}