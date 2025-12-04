 import 'package:flutter/material.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

class LoadingIndicatorUtils extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const LoadingIndicatorUtils({
    super.key,
    this.size = 25.0,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveSize = ResponsiveHelper.iconSize(context, size);
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.secondary;

    return Center(
      child: SizedBox(
        height: responsiveSize,
        width: responsiveSize,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[300],
        ),
      ),
    );
  }

}
