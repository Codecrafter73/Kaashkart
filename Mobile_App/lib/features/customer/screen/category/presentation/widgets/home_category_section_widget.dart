import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/core/utls/divider_separation_widget_util.dart';
import 'package:kaashtkart/core/utls/image_loader_util.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';


class HomeCategorySection extends StatefulWidget {
  final String? sectionHeading;

  const HomeCategorySection({
    super.key,
    this.sectionHeading,
  });

  @override
  State<HomeCategorySection> createState() => _HomeCategorySectionState();
}

class _HomeCategorySectionState extends State<HomeCategorySection> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive column calculation
    int columns;
    double cardSpacing;
    double mainAxisSpacing;

    if (ResponsiveHelper.isDesktop(context)) {
      columns = 8;
      cardSpacing = 14.0;
      mainAxisSpacing = 20.0;
    } else if (ResponsiveHelper.isTablet(context)) {
      columns = screenWidth > 1300 && screenWidth < 1880 ? 6 : 5;
      cardSpacing = 12.0;
      mainAxisSpacing = 16.0;
    } else {
      columns = 4;
      cardSpacing = 10.0;
      mainAxisSpacing = 16.0;
    }

    final services = _getServicesData();
    final displayedServices = services.take(columns * 2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CommonDivider(),
        SizedBox(height: AppDefaults.verticalSpacing),

        Padding(
          padding: ResponsiveHelper.paddingSymmetric(
            context,
            horizontal: ResponsiveHelper.isMobile(context) ? 16.0 : 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.sectionHeading ?? "Category",
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, AppDefaults.sectionHeadingSize),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDefaults.verticalSpacing / 1.2),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: ResponsiveHelper.paddingSymmetric(
            context,
            horizontal: ResponsiveHelper.isMobile(context) ? 16.0 : 20.0,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: cardSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: 0.7, // Adjusted for better proportions
          ),
          itemCount: displayedServices.length,
          itemBuilder: (context, index) {
            final item = displayedServices[index];
            return _buildServiceCard(
              context,
              item['title'],
              item['image'],
              item['color'],
            );
          },
        ),
        SizedBox(height: AppDefaults.verticalSpacing),

        const CommonDivider(),
      ],
    );
  }

  Widget _buildServiceCard(
      BuildContext context,
      String title,
      String imagePath,
      Color backgroundColor,
      ) {
    final bool isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () {
        print('Tapped on: $title');
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Card Container with Fixed Aspect Ratio for Image
          AspectRatio(
            aspectRatio: 1.0, // Perfect square for consistent look
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: ResponsiveHelper.paddingAll(context, isMobile ? 10.0 : 16.0),
              child: ImageLoaderUtil.assetImage(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Fixed height spacer
          SizedBox(height: isMobile ? 6.0 : 8.0),

          // Title with Fixed Height Container (2 lines max)
          Container(
            height: isMobile ? 28.0 : 32.0, // Fixed height for 2 lines
            alignment: Alignment.topCenter,
            padding: ResponsiveHelper.paddingSymmetric(context, horizontal: 4),
            child: Text(
              title,
              style: AppTextStyles.caption(
                context,
                overrideStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: ResponsiveHelper.fontSize(context, isMobile ? 10 : 12),
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  letterSpacing: -0.1,
                ),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getServicesData() {
    return [
      {
        'title': 'Vegetables & Fruits',
        'image': 'assets/images/product_4.png',
        'color': Color(0xFFE8F5E9),
      },
      {
        'title': 'Atta, Rice & Dal',
        'image': 'assets/images/product_4.png',
        'color': Color(0xFFFFF8E1),
      },
      {
        'title': 'Oil, Ghee & Masala',
        'image': 'assets/images/product_5.png',
        'color': Color(0xFFFCE4EC),
      },
      {
        'title': 'Dairy, Bread & Eggs',
        'image': 'assets/images/product_6.png',
        'color': Color(0xFFE3F2FD),
      },
      {
        'title': 'Bakery & Biscuits',
        'image': 'assets/images/product_4.png',
        'color': Color(0xFFFFF3E0),
      },
      {
        'title': 'Dry Fruits & Cereals',
        'image': 'assets/images/product_4.png',
        'color': Color(0xFFFFF9C4),
      },
      {
        'title': 'Chicken, Meat & Fish',
        'image': 'assets/images/product_3.png',
        'color': Color(0xFFFFEBEE),
      },
      {
        'title': 'Kitchenware & Appliances',
        'image': 'assets/images/product_5.png',
        'color': Color(0xFFE0F2F1),
      },
    ];
  }
}