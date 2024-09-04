import 'package:flutter/material.dart';

class ScreenSize {
  static double width = 0;
  static double height = 0;

  static ScreenSizeType get type {
    if (width < 600) {
      return ScreenSizeType.mobile;
    } else if (width < 1200) {
      return ScreenSizeType.tablet;
    } else {
      return ScreenSizeType.desktop;
    }
  }

  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}

enum ScreenSizeType {
  mobile,
  tablet,
  desktop,
}
