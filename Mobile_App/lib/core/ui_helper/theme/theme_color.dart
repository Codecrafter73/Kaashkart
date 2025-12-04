 import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/theme/theme_provider.dart';
import 'package:provider/provider.dart';


class ThemeColors {
  static Color background(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return isDark ? AppColors.primary : AppColors.whiteColor;
  }

  static Color text(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return isDark ? AppColors.primary : AppColors.whiteColor;
  }

  static Color primary(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return isDark ? AppColors.primary : AppColors.whiteColor;
  }
}
