import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color main700 = Color(0xFF3A0E40);
  static const Color main600 = Color(0xFF9D42E8);
  static const Color main500 = Color(0xFFB077E5);
  static const Color main400 = Color(0xFF9C77BE);
  static const Color main300 = Color(0xFFFBECFF);

  static const Color background = Color(0xFFF9E3FF);
  static const Color bg_1 = Color(0xFFFDF5FF);
  static const Color lightPurple = Color(0xFFB599CE);
  static const Color homeCards = Color(0xFFFBECFF);

  //neutral
  static const Color purpleGrey = Color(0xFFD7D0DD);
  static const Color white = Colors.white;

  //pinks
  static const Color pink600 = Color(0xFFFB64B6);
  static const Color pink500 = Color(0xFFFF91C7);
  static const Color pink400 = Color(0xFFFDA5D5);
  static const Color pink300 = Color(0xFFFBD4F6);
  static const Color pink200 = Color(0xFFF9E3FF);

  //blues
  static const Color blue600 = Color(0xFF3D9EFF);
  static const Color blue500 = Color(0xFF6AB4FF);
  static const Color blue400 = Color(0xFF91C8FF);
  static const Color blue300 = Color(0xFFC2E0FF);
  static const Color blue200 = Color(0xFFE1F0FF);


  // Text
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFFCAD5E2);
  static const Color textLight = Colors.white;
  static const Color textDark = Colors.black;

  // Status colors
  static const Color alerts = Color(0xff9D42E8);

  // Borders & dividers

  //gradients

  static const Gradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0xFFB599CE),
    ],
  );
}
