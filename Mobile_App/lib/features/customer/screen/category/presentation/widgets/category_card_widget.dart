import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';


class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card Container with Image
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
            ),
            padding: ResponsiveHelper.paddingAll(context, 0),
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    size: ResponsiveHelper.iconSize(context, 32),
                    color: Colors.grey[400],
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(height: ResponsiveHelper.spacing(context, 8)),

        // Category Title
        Text(
          title,
          style: AppTextStyles.caption(
            context,
            overrideStyle: TextStyle(
              color: Colors.black87,
              fontSize: ResponsiveHelper.fontSize(context, 10),
              fontWeight: FontWeight.w500,
            ),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
