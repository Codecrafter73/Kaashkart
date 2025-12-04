
import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.paddingSymmetric(
        context,
        horizontal: 20,
        vertical: 16,
      ),
      child: Container(
        height: ResponsiveHelper.containerHeight(context, 50),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
        ),
        child: Row(
          children: [
            // Search Icon
            Padding(
              padding: ResponsiveHelper.paddingOnly(
                context,
                left: 16,
                right: 12,
              ),
              child: Icon(
                Icons.search,
                color: Colors.grey[600],
                size: ResponsiveHelper.iconSize(context, 24),
              ),
            ),

            // Search Text Field
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search "ice-cream"',
                  hintStyle: AppTextStyles.body2(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                    ),
                  ),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.body1(context),
              ),
            ),

            // Mic Icon
            Padding(
              padding: ResponsiveHelper.paddingOnly(
                context,
                right: 16,
                left: 8,
              ),
              child: Icon(
                Icons.mic_none,
                color: Colors.grey[600],
                size: ResponsiveHelper.iconSize(context, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}