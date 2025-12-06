import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/core/utls/image_loader_util.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/auth/customer_login_screen.dart';
import 'package:kaashtkart/features/auth/vendor_registration_screen.dart';

class IntroPageBodyArea extends StatefulWidget {
  const IntroPageBodyArea({super.key});

  @override
  State<IntroPageBodyArea> createState() => _IntroPageBodyAreaState();
}

class _IntroPageBodyAreaState extends State<IntroPageBodyArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animation - starts first
    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    // Title animation - starts after logo
    _titleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );

    // Subtitle animation
    _subtitleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );

    // Button animation
    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
    );

    // Bottom image animation
    _imageAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green[100]!],
              ),
            ),
          ),

          // Content
          Column(
            children: [
              const Spacer(flex: 2),

              // Animated Logo
              FadeTransition(
                opacity: _logoAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(_logoAnimation),
                  child: Container(
                    width: ResponsiveHelper.containerWidth(context, 250),
                    child: ImageLoaderUtil.assetImage(
                      'assets/images/transparent_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Animated Title
              FadeTransition(
                opacity: _titleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_titleAnimation),
                  child: Column(
                    children: [
                      Text(
                        'Get Desi Products',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.fontSize(context, 26),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Directly From Farmers',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.fontSize(context, 26),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ResponsiveHelper.sizedBoxHeight(context, 15),

              // Animated Subtitle
              FadeTransition(
                opacity: _subtitleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_subtitleAnimation),
                  child: Padding(
                    padding: ResponsiveHelper.paddingSymmetric(
                      context,
                      horizontal: 40,
                    ),

                    child: Text(
                      'The Best Delivery App in Town For\nDelivering Your Daily Fresh Products',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body1(
                        context,
                        overrideStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ResponsiveHelper.sizedBoxHeight(context, 25),

              // Animated Button
              FadeTransition(
                opacity: _buttonAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0)
                      .animate(_buttonAnimation),
                  child: Padding(
                    padding: ResponsiveHelper.paddingSymmetric(
                      context,
                      horizontal: AppDefaults.padding * 3,
                    ),
                    child: CustomButton(
                      textColor: AppColors.whiteColor,
                      text: "Continue with Email or Phone",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerLoginFormScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Animated Bottom Image
              FadeTransition(
                opacity: _imageAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_imageAnimation),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: ResponsiveHelper.screenHeight(context) * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/user_selection_background_image.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}