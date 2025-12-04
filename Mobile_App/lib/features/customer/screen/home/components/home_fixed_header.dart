import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/locatino_manager.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_list_screen.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_controller.dart';
import 'package:provider/provider.dart';


class FixedHeader extends StatefulWidget {
  const FixedHeader({super.key});

  @override
  State<FixedHeader> createState() => _FixedHeaderState();
}

class _FixedHeaderState extends State<FixedHeader> {
  String _address = "Fetching location...";
  bool isLoadingAddress = true;

  // Rotating search texts
  final List<String> _searchTexts = [
    "Search for Apple",
    "Search for Oil",
    "Search for Organic Fruits",
    "Book CBC, X-ray, etc.",
    "Find Lab Tests, MRI, CT Scan",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchLocation();

    // Auto rotate every 2.8 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 2800), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _searchTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    try {
      setState(() => isLoadingAddress = true);

      final cachedData = await LocationUtil.getCurrentLocationWithAddress(useCache: true);
      String formattedAddress = "Unknown location";

      if (cachedData != null) {
        final addressMap = cachedData["address"];
        formattedAddress = addressMap["formattedAddress"] ?? "Unknown location";
      } else {
        final data = await LocationUtil.getCurrentLocationWithAddress(useCache: false);
        final addressMap = data?["address"];
        formattedAddress = addressMap?["formattedAddress"] ?? "Location unavailable";
      }

      if (mounted) {
        setState(() {
          _address = formattedAddress;
          isLoadingAddress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = "Location unavailable";
          isLoadingAddress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: ResponsiveHelper.paddingSymmetric(context, horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: ResponsiveHelper.containerWidth(context, 34),
                        height: ResponsiveHelper.containerHeight(context, 34),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.person_outline, color: AppColors.primary, size: 22),
                      ),
                      ResponsiveHelper.sizedBoxWidth(context,8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Ashish Kumar',
                              style: AppTextStyles.heading1(context).copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isLoadingAddress ? "Fetching location..." : _address,
                              style: AppTextStyles.body1(context).copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Icon with Badge
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      final itemCount = cart.totalUniqueItems; // ← Naya CartProvider: totalItems
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(padding: ResponsiveHelper.paddingAll(context,6), child: Icon(Icons.shopping_cart_checkout_outlined, color: Colors.white, size: ResponsiveHelper.iconSize(context, 22)),),
                          if (itemCount > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: ResponsiveHelper.paddingAll(context,1),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: Text(
                                  itemCount.toString(),
                                  style: AppTextStyles.heading1(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: ResponsiveHelper.containerWidth(context, 34),
                padding: ResponsiveHelper.paddingSymmetric(context, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 0.4,
                    color: AppColors.txtGreyColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 1.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: ResponsiveHelper.isTablet(context)
                          ? ResponsiveHelper.iconSize(context, 30)
                          : ResponsiveHelper.iconSize(context, 18),
                    ),
                    ResponsiveHelper.sizedBoxWidth(context, 8),
                    AnimatedTextKit(
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      pause: Duration.zero,
                      animatedTexts: [
                        RotateAnimatedText(
                          'Search for ',
                          duration: const Duration(milliseconds: 2000),
                          textStyle: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: AppColors.txtGreyColor,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                        RotateAnimatedText(
                          'Search for ',
                          duration: const Duration(milliseconds: 2000),
                          textStyle: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: AppColors.txtGreyColor,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                        RotateAnimatedText(
                          'Search for Organic ',
                          duration: const Duration(milliseconds: 2000),
                          textStyle: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: AppColors.txtGreyColor,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                      ],
                      onNextBeforePause: (index, _) {
                        setState(() {});
                      },
                    ),
                    // Last word with green color
                    AnimatedTextKit(
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      pause: Duration.zero,
                      animatedTexts: [
                        RotateAnimatedText(
                          'Apple',
                          duration: const Duration(milliseconds: 2000),
                          textStyle: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: AppColors.primary,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                        RotateAnimatedText(
                          'Oil',
                          duration: const Duration(milliseconds: 2000),
                          textStyle: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: AppColors.primary,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                        RotateAnimatedText(
                          'Fruits',
                          duration: const Duration(milliseconds: 2000),
                          textStyle: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: AppColors.primary,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                      ],
                      onNextBeforePause: (index, _) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}