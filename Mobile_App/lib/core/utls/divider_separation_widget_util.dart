import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';


class CommonDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const CommonDivider({
    super.key,
    this.height = 8.0,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: color ?? AppColors.lightBlueColor,
      margin: margin,
    );
  }
}
