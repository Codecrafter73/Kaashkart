import 'package:flutter/material.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'bottom_app_bar_item.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';


class VendorAppBottomNavigationBar extends StatelessWidget {
  const VendorAppBottomNavigationBar({
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
              VendorBottomAppBarItemWithBackground(
                name: 'Home',
                iconData: Icons.dashboard,
                isActive: currentIndex == 0,
                onTap: () => onNavTap(0),
              ),
              VendorBottomAppBarItemWithBackground(
                name: 'Orders',
                iconData: Icons.list_alt,
                isActive: currentIndex == 1,
                onTap: () => onNavTap(1),
              ),
              // Cart item - ab same line me hai
              VendorBottomAppBarItemWithBackground(
                name: 'Products',
                iconData: Icons.inventory_2,
                isActive: currentIndex == 2,
                onTap: () => onNavTap(2),
                iconSize: 24,
              ),
              VendorBottomAppBarItemWithBackground(
                name: 'Report',
                iconData: Icons.receipt_long,
                isActive: currentIndex == 3,
                onTap: () => onNavTap(3),
                iconSize: 24,
              ),
              VendorBottomAppBarItemWithBackground(
                name: 'Profile',
                iconData: Icons.person,
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
