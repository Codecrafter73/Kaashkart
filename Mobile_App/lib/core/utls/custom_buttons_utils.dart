import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

enum ButtonType { solid, outlined }
enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final IconData? iconData;
  final Widget? customIcon; // NEW: Allows Image/SVG etc.
  final double? iconSize;
  final Color? iconColor;
  final double iconSpacing;
  final IconPosition iconPosition;
  final ButtonType type;
  final Color? borderColor;
  final Color? disabledColor;

  const CustomButton({
    super.key,
    this.text = '',
    this.color = const Color(0xFF177e3f),
    this.textColor = Colors.white,
    this.borderRadius = 12.0,
    this.height = 36.0,
    this.width = double.infinity,
    required this.onPressed,
    this.textStyle,
    this.iconData,
    this.customIcon,
    this.iconSize,
    this.iconColor,
    this.iconSpacing = 8.0,
    this.iconPosition = IconPosition.left,
    this.type = ButtonType.solid,
    this.borderColor,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final double btnHeight = ResponsiveHelper.containerHeight(context, height);
    final double btnWidth = width == double.infinity
        ? double.infinity
        : ResponsiveHelper.containerWidth(context, width);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: type == ButtonType.outlined
          ? BorderSide(color: borderColor ?? color, width: 1)
          : BorderSide.none,
    );

    final ButtonStyle style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor ?? color.withOpacity(0.5);
          }
          return type == ButtonType.solid ? color : Colors.transparent;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
          if (states.contains(WidgetState.disabled)) {
            return textColor.withAlpha(60);
          }
          return textColor;
        },
      ),
      elevation: WidgetStateProperty.all<double>(type == ButtonType.solid ? 2 : 0),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(shape),
      minimumSize: WidgetStateProperty.all<Size>(Size(btnWidth, btnHeight)),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.spacing(context, 16),
          vertical: ResponsiveHelper.spacing(context, 8),
        ),
      ),
    );

    // --- ICON WIDGET BUILDER ---
    Widget? buildIcon() {
      if (customIcon != null) {
        return customIcon!;
      } else if (iconData != null) {
        return Icon(
          iconData,
          size: ResponsiveHelper.iconSize(context, iconSize ?? 18),
          color: type == ButtonType.outlined
              ? (iconColor ?? borderColor ?? color)
              : (iconColor ?? textColor),
        );
      }
      return null;
    }

    final iconWidget = buildIcon();

    final textWidget = Text(
      text,
      style: textStyle ??
          AppTextStyles.body1(context,
              overrideStyle: const TextStyle(fontSize: 14)).copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
    );

    // --- FINAL BUTTON LAYOUT ---
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null && iconPosition == IconPosition.left) ...[
            iconWidget,
            SizedBox(width: iconSpacing),
          ],
          textWidget,
          if (iconWidget != null && iconPosition == IconPosition.right) ...[
            SizedBox(width: iconSpacing),
            iconWidget,
          ],
        ],
      ),
    );
  }
}












//
// import 'package:flutter/material.dart';
// import 'package:kaashtkart/utls/responsive_helper_utils.dart';
//
// import '../ui_helper/app_text_styles.dart';
//
// enum ButtonType { solid, outlined }
//
// class CustomButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final Color textColor;
//   final double borderRadius;
//   final double height;
//   final double width;
//   final VoidCallback? onPressed;
//   final TextStyle? textStyle;
//   final IconData? iconData;
//   final double? iconSize;
//   final Color? iconColor;
//   final ButtonType type;
//   final Color? borderColor;
//   final Color? disabledColor; // NEW
//
//   const CustomButton({
//     Key? key,
//     this.text = '',
//     this.color = const Color(0xFF075271),
//     this.textColor = Colors.white,
//     this.borderRadius = 12.0,
//     this.height = 36.0,
//     this.width = double.infinity,
//     required this.onPressed,
//     this.textStyle,
//     this.iconData,
//     this.iconSize,
//     this.iconColor,
//     this.type = ButtonType.solid,
//     this.borderColor,
//     this.disabledColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final double btnHeight = ResponsiveHelper.containerHeight(context, height);
//     final double btnWidth = width == double.infinity
//         ? double.infinity
//         : ResponsiveHelper.containerWidth(context, width);
//
//     final shape = RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(borderRadius),
//       side: type == ButtonType.outlined
//           ? BorderSide(color: borderColor ?? color, width: 1)
//           : BorderSide.none,
//     );
//
//     final ButtonStyle style = ButtonStyle(
//       backgroundColor: WidgetStateProperty.resolveWith<Color>(
//             (states) {
//           if (states.contains(WidgetState.disabled)) {
//             return disabledColor ?? color;
//           }
//           return type == ButtonType.solid ? color : Colors.transparent;
//         },
//       ),
//       foregroundColor: WidgetStateProperty.resolveWith<Color>(
//             (states) {
//           if (states.contains(WidgetState.disabled)) {
//             return textColor.withAlpha(60);
//           }
//           return textColor;
//         },
//       ),
//       elevation: WidgetStateProperty.all<double>(type == ButtonType.solid ? 2 : 0),
//       shape: WidgetStateProperty.all<RoundedRectangleBorder>(shape),
//       minimumSize: WidgetStateProperty.all<Size>(Size(btnWidth, btnHeight)),
//       padding: WidgetStateProperty.all<EdgeInsets>(
//         EdgeInsets.symmetric(
//           horizontal: ResponsiveHelper.spacing(context, 16),
//           vertical: ResponsiveHelper.spacing(context, 8),
//         ),
//       ),
//     );
//
//
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: style,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (iconData != null)
//             Icon(
//               iconData,
//               size: ResponsiveHelper.iconSize(context, iconSize ?? 18),
//               color: type == ButtonType.outlined
//                   ? (iconColor ?? borderColor ?? color)
//                   : textColor,
//             ),
//           if (text.isNotEmpty) ...[
//             if (iconData != null) const SizedBox(width: 8),
//             Text(
//               text,
//               style: textStyle ??
//                   AppTextStyles.body1(context,overrideStyle: TextStyle(fontSize: 14)).copyWith(
//                     color: textColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
