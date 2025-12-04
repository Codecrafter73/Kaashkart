import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_list_screen.dart';
import 'package:kaashtkart/features/customer/screen/home/home_screen.dart';
import 'package:kaashtkart/features/customer/screen/category/presentation/screen/category_list_screen.dart';
import 'package:kaashtkart/features/customer/screen/customer/screen/profile_screem.dart';
import 'package:kaashtkart/features/customer/screen/wishlist/wishlist_screen.dart';
import 'components/app_navigation_bar.dart';

class CustomerEntryPointUI extends StatefulWidget {
  const CustomerEntryPointUI({super.key});

  @override
  State<CustomerEntryPointUI> createState() => _CustomerEntryPointUIState();
}

class _CustomerEntryPointUIState extends State<CustomerEntryPointUI> {
  int currentIndex = 0;

  void onBottomNavigationTap(int index) {
    currentIndex = index;
    setState(() {});
  }

  List<Widget> pages = [
    const HomeScreen(),
    const CategoryListScreen(showBackButton: false,), // Replace with Explore Screen
    const CartScreen(showBackButton: false,), // Replace with Cart Screen
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
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onNavTap: onBottomNavigationTap,
      ),
    );
  }
}