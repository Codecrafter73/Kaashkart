import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/features/customer/screen/category/presentation/screen/category_list_screen.dart';
import 'package:kaashtkart/features/customer/screen/customer/screen/profile_screem.dart';
import 'package:kaashtkart/features/customer/screen/wishlist/wishlist_screen.dart';
import 'package:kaashtkart/features/vendor/bottom_navigation/components/app_navigation_bar.dart';
import 'package:kaashtkart/features/vendor/products/screen/vendor_products_list_screem.dart';
import 'package:kaashtkart/features/vendor/vendor_home/vendor_home_screen.dart';

class VendorEntryPointUI extends StatefulWidget {
  const VendorEntryPointUI({super.key});

  @override
  State<VendorEntryPointUI> createState() => _VendorEntryPointUIState();
}

class _VendorEntryPointUIState extends State<VendorEntryPointUI> {
  int currentIndex = 0;

  void onBottomNavigationTap(int index) {
    currentIndex = index;
    setState(() {});
  }

  List<Widget> pages = [
    const VendorHomeScreen(),
    const CategoryListScreen(showBackButton: false,), // Replace with Explore Screen
    const VendoeProductListScreen(), // Replace with Cart Screen
    const WishlistProductSection(), // Replace with Favourite Screen
    const ProfileScreen(), // Profile Screen added
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: AppColors.whiteColor,
            child: child,
          );
        },
        duration: AppDefaults.duration,
        child: pages[currentIndex],
      ),
      bottomNavigationBar: VendorAppBottomNavigationBar(
        currentIndex: currentIndex,
        onNavTap: onBottomNavigationTap,
      ),
    );
  }
}