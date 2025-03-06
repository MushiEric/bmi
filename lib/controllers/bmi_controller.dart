import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class BMIController extends GetxController {
  var heightController = TextEditingController();
  var weightController = TextEditingController();
  var heightUnit = "cm".obs;  // Default is cm
  var weightUnit = "kg".obs;  // Default is kg
  var bmi = 0.0.obs;
  var status = "".obs;

  var heightError = "".obs;
  var weightError = "".obs;
  var isValid = false.obs; // Controls button activation

  void validateInput() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);

    // ✅ Height Validation
    if (height == null || _convertHeightToCM(height) < 54.6 || _convertHeightToCM(height) > 251) {
      heightError.value = "Height must be between 54.6 cm and 251 cm.";
    } else {
      heightError.value = "";
    }

    // ✅ Weight Validation
    if (weight == null || _convertWeightToKG(weight) < 10 || _convertWeightToKG(weight) > 635) {
      weightError.value = "Weight must be between 10 kg and 635 kg.";
    } else {
      weightError.value = "";
    }

    // ✅ Enable button only if there are no errors
    isValid.value = heightError.value.isEmpty && weightError.value.isEmpty;
  }

  void calculateBMI() {
    validateInput(); // ✅ Revalidate before calculation

    if (!isValid.value) {
      Get.snackbar("Invalid Input", "Please enter valid height and weight.", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);

    height = _convertHeightToMeters(height); // ✅ Convert height to meters
    weight = _convertWeightToKG(weight); // ✅ Convert weight to kg

    bmi.value = weight / pow(height, 2);

    // ✅ BMI Categories
    if (bmi.value < 18.5) {
      status.value = "Underweight";
    } else if (bmi.value >= 18.5 && bmi.value < 24.9) {
      status.value = "Normal";
    } else if (bmi.value >= 25 && bmi.value < 29.9) {
      status.value = "Overweight";
    } else {
      status.value = "Obese";
    }

    Get.toNamed('/result');
  }

  // ✅ Convert Height to Meters
  double _convertHeightToMeters(double height) {
    if (heightUnit.value == "feet") {
      return height * 0.3048; // Convert feet to meters
    } else if (heightUnit.value == "inches") {
      return height * 0.0254; // Convert inches to meters
    } else {
      return height / 100; // Convert cm to meters
    }
  }

  // ✅ Convert Height to CM (for validation)
  double _convertHeightToCM(double height) {
    if (heightUnit.value == "feet") {
      return height * 30.48; // Convert feet to cm
    } else if (heightUnit.value == "inches") {
      return height * 2.54; // Convert inches to cm
    } else {
      return height; // Already in cm
    }
  }

  // ✅ Convert Weight to KG
  double _convertWeightToKG(double weight) {
    if (weightUnit.value == "lbs") {
      return weight * 0.453592; // Convert lbs to kg
    } else {
      return weight; // Already in kg
    }
  }
  void clearFields() {
  heightController.clear();
  weightController.clear();
  bmi.value = 0.0;
  status.value = "";
  heightError.value = "";
  weightError.value = "";
  isValid.value = false;
}

}
