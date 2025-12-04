import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/auth/customer_login_screen.dart';
import 'package:kaashtkart/features/auth/vendor_registration_screen.dart';
class IntroPageBodyArea extends StatelessWidget {
  const IntroPageBodyArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // const Spacer(flex: 1),
          ResponsiveHelper.sizedBoxHeight(context, 20),
          Padding(
            padding: ResponsiveHelper.paddingAll(context,AppDefaults.padding),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to our',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ResponsiveHelper.fontSize(context, 24),
                      ),
                    ),
                  ),
                  Text(
                    'E-Grocery',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: ResponsiveHelper.fontSize(context, 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 5),
          Padding(
            padding: ResponsiveHelper.paddingAll(context,AppDefaults.padding),
            child: Column(
              children: [
                CustomButton(
                  color: AppColors.primary,
                  text: "Continue with Email or Phone",
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VendorRegistrationFormScreen()),
                    );

                  },
                ),
                ResponsiveHelper.sizedBoxHeight(context, 5),
                CustomButton(
                  color: AppColors.whiteColor,
                  textColor: AppColors.blackColor,
                  text: "Continue with Email or Phone",
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomerLoginFormScreen()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
