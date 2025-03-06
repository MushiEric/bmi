import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final double size;

  const CustomBackButton({Key? key, this.color, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: size, color: color ?? Colors.white),
      onPressed: () => Get.back(), // ✅ Navigate back one step
    );
  }
}
