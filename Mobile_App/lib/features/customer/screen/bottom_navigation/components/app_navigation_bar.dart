import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/core/utls/constants/app_icons.dart';
import 'bottom_app_bar_item.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding /50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomAppBarItemWithBackground(
                name: 'Home',
                iconLocation: AppIcons.home,
                isActive: currentIndex == 0,
                onTap: () => onNavTap(0),
              ),
              BottomAppBarItemWithBackground(
                name: 'Category',
                iconLocation: AppIcons.category,
                isActive: currentIndex == 1,
                onTap: () => onNavTap(1),
              ),
              // Cart item - ab same line me hai
              BottomAppBarItemWithBackground(
                name: 'Cart',
                iconLocation: AppIcons.cart,
                isActive: currentIndex == 2,
                onTap: () => onNavTap(2),
                iconSize: 30,
              ),
              BottomAppBarItemWithBackground(
                name: 'Wishlist',
                iconLocation: AppIcons.heart,
                isActive: currentIndex == 3,
                onTap: () => onNavTap(3),
                iconSize: 28,
              ),
              BottomAppBarItemWithBackground(
                name: 'Profile',
                iconLocation: AppIcons.nav_profile,
                isActive: currentIndex == 4,
                onTap: () => onNavTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
