import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'dart:math';

enum ColorTheme { Light, Dark, Rainbow }

class AppColors {
  late Color appBarColor;
  late Color backGroundColor;
  late Color textColor;

  // Constructor to set the color theme
  AppColors(ColorTheme theme) {
    _setTheme(theme);
  }

  // Method to set the color theme based on the selected theme
  void setTheme(ColorTheme theme) {
    _setTheme(theme);
    //notifyListeners();
  }

  // Method to generate random values
  void _generateRandomColors() {
    Random random = Random();

    appBarColor = Color.fromARGB(random.nextInt(256), random.nextInt(256), random.nextInt(256), random.nextInt(256));
    backGroundColor = Color.fromARGB(random.nextInt(256), random.nextInt(256), random.nextInt(256), random.nextInt(256));
    textColor = Color.fromARGB(random.nextInt(256), random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }

  // Method to set the color theme based on the selected theme
  void _setTheme(ColorTheme theme) {
    switch (theme) {
      case ColorTheme.Light:
        appBarColor = const Color.fromARGB(255, 229, 57, 53);
        backGroundColor = Colors.white;
        textColor = Colors.black;
        break;
      case ColorTheme.Dark:
        appBarColor = const Color.fromARGB(255, 77, 1, 0);
        backGroundColor = const Color.fromARGB(255, 32, 32, 32);
        textColor = Colors.white;
        break;
      case ColorTheme.Rainbow:
        _generateRandomColors();
        break;
    }
  }
}
