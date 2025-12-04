import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

class VendorBottomAppBarItem extends StatelessWidget {
  const VendorBottomAppBarItem({
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
          padding: ResponsiveHelper.paddingSymmetric(
            context,
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
                  height: ResponsiveHelper.containerWidth(context, 24),
                  width: ResponsiveHelper.containerHeight(context, 24),
                  colorFilter: ColorFilter.mode(
                    isActive
                        ? AppColors.primary
                        : Colors.grey.shade600, // ✅ Consistent color
                    BlendMode.srcIn,
                  ),
                ),
              ),
              ResponsiveHelper.sizedBoxHeight(context, 4),
              Text(
                name,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    color: isActive ? AppColors.primary : Colors.grey.shade600,
                    // ✅ Consistent color
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
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

class VendorBottomAppBarItemWithBackground extends StatelessWidget {
  const VendorBottomAppBarItemWithBackground({
    super.key,
    required this.name,
    this.iconLocation, // SVG path
    this.iconData, // Normal Flutter icon
    required this.isActive,
    required this.onTap,
    this.iconSize = 24,
  }) : assert(
         iconLocation != null || iconData != null,
         'Either iconLocation (SVG) or iconData (IconData) must be provided',
       );

  final String name;
  final String? iconLocation;
  final IconData? iconData;
  final bool isActive;
  final void Function() onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDefaults.radius),
        child: Padding(
          padding: ResponsiveHelper.paddingSymmetric(
            context,
            vertical: AppDefaults.padding / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: ResponsiveHelper.paddingAll(context, 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildIcon(), // ✅ Auto choose SVG or Icon
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    color: isActive ? AppColors.primary : Colors.grey.shade600,
                    // ✅ Consistent color
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
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

  /// ✅ Automatically choose between SVG and normal Icon
  Widget _buildIcon() {
    if (iconData != null) {
      return Icon(
        iconData,
        size: iconSize,
        color: isActive ? AppColors.primary : Colors.grey.shade600,
      );
    } else {
      return SvgPicture.asset(
        iconLocation!,
        height: iconSize,
        width: iconSize,
        colorFilter: ColorFilter.mode(
          isActive ? AppColors.primary : Colors.grey.shade600,
          BlendMode.srcIn,
        ),
      );
    }
  }
}
