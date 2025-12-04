import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

class BottomSheetUtils {
  static void showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: ResponsiveHelper.paddingAll(context,16.0),
          child: Column( // <-- This Column
            mainAxisSize: MainAxisSize.min, // <-- This is a common culprit for bottom overflows
            children: [
              /// Top Handle
              Container(width: 80, height: 5, color: Colors.grey[400]),
              ResponsiveHelper.sizedBoxHeight(context, 10),

              Padding(
                padding: ResponsiveHelper.paddingSymmetric(context,horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Icon(Icons.error_outline, color: Colors.red, size: ResponsiveHelper.circleRadius(context, 40)),
                    ResponsiveHelper.sizedBoxHeight(context, 10),
                    Text(
                      "Sign out from Account",
                      style: AppTextStyles.body1(
                        context,
                        overrideStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 8),
                    Text(
                      "Are you sure you would like to Logout of your Account?",
                      style: AppTextStyles.body1(
                        context,
                        overrideStyle: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 20),
                  ],
                ),
              ),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Cancel Button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:ResponsiveHelper.paddingSymmetric(context,horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  /// Logout Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // Provider.of<AuthApiProvider>(
                      //   context,
                      //   listen: false,
                      // ).logoutUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: ResponsiveHelper.paddingSymmetric(context,horizontal: 40, vertical: 12),
                    ),
                    child: Text( // <-- The "Logout" text
                      "Logout",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ResponsiveHelper.sizedBoxHeight(context,10),
            ],
          ),
        );
      },
    );
  }
}