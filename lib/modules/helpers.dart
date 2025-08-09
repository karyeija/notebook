import 'package:flutter/material.dart';

class UIHelpers {
  // This class can contain static methods for UI-related helpers.
  // For example, you can add methods to create common widgets, styles, etc.
  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
