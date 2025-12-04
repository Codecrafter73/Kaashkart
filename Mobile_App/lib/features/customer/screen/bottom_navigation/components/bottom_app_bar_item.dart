import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';

class BottomAppBarItem extends StatelessWidget {
  const BottomAppBarItem({
    super.key,
    required this.name,
    required this.iconLocation,
    this.filledIconLocation, // Optional filled icon path
    required this.isActive,
    required this.onTap,
  });

  final String name;
  final String iconLocation;
  final String? filledIconLocation; // Filled version ka icon path
  final bool isActive;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDefaults.radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDefaults.padding / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Container for smooth transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  // Agar filled icon available hai aur active hai to filled use karo
                  isActive && filledIconLocation != null
                      ? filledIconLocation!
                      : iconLocation,
                  key: ValueKey(isActive),
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    isActive
                        ? AppColors.primary
                        : Colors.grey.shade600, // ✅ Consistent color
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.primary
                      : Colors.grey.shade600, // ✅ Consistent color
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// ALTERNATIVE SOLUTION - Container Background
// ============================================

class BottomAppBarItemWithBackground extends StatelessWidget {
  const BottomAppBarItemWithBackground({
    super.key,
    required this.name,
    required this.iconLocation,
    required this.isActive,
    required this.onTap,
    this.iconSize = 24,
  });

  final String name;
  final String iconLocation;
  final bool isActive;
  final void Function() onTap;
  final double iconSize; // ✅ Optional parameter

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDefaults.radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDefaults.padding / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background container when active
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  iconLocation,
                  height: iconSize, // ✅ Use optional size
                  width: iconSize,
                  colorFilter: ColorFilter.mode(
                    isActive
                        ? AppColors.primary
                        : Colors.black, // ✅ Consistent color for all inactive icons
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.primary
                      : Colors.grey.shade600, // ✅ Consistent color
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}