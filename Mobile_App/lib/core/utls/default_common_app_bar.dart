 import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

class DefaultCommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String activityName;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onBack;
  final Color backgroundColor;

  final IconData? leadingIcon; // Optional custom back/leading icon
  final double? iconSize; // Optional icon size
  final TextStyle? customTitleStyle; // Optional custom title style

  // ✅ NEW: Optional Action Icons
  final List<IconData>? actionIcons; // list of icons (e.g. [Icons.refresh, Icons.search])
  final List<VoidCallback?>? onActionTap; // callbacks matching each icon

  const DefaultCommonAppBar({
    super.key,
    required this.activityName,
    this.onBack,
    this.iconColor = Colors.white,
    this.titleColor = Colors.white,
    this.backgroundColor = const Color(0xFF177e3f),
    this.leadingIcon,
    this.iconSize,
    this.customTitleStyle,
    this.actionIcons,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Text(
        activityName,
        style: customTitleStyle ??
            AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontSize: 16,
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
      leading: IconButton(
        icon: Icon(
          leadingIcon ?? Icons.arrow_back,
          color: iconColor,
          size: iconSize ?? 22,
        ),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),

      // ✅ Action Icons (optional)
      actions: actionIcons != null
          ? List.generate(actionIcons!.length, (index) {
        return IconButton(
          padding: ResponsiveHelper.paddingOnly(context,right: 10),
          icon: Icon(
            actionIcons![index],
            color: iconColor,
            size: iconSize ?? 22,
          ),
          onPressed: onActionTap != null &&
              onActionTap!.length > index &&
              onActionTap![index] != null
              ? onActionTap![index]
              : null,
        );
      })
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
