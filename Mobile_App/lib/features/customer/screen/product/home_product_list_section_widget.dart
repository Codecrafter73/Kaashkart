import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/divider_separation_widget_util.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/home/components/single_add_bottomsheet_widget.dart';
import 'package:kaashtkart/features/customer/screen/product/product_detail_bottom_sheet_widget.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';


class HomelProductListSection extends StatefulWidget {
  final String? sectionHeading;

  const HomelProductListSection({super.key, this.sectionHeading});

  @override
  State<HomelProductListSection> createState() =>
      _HomelProductListSectionState();
}

class _HomelProductListSectionState extends State<HomelProductListSection> {
  bool _isBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final products = _getProductsData();

    return Padding(
      // Yeh hai main change — upar aur neeche equal spacing
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.spacing(context, 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section (bilkul same)
          Padding(
            padding: ResponsiveHelper.paddingOnly(
              context,
              left: ResponsiveHelper.spacing(context, 16),
              right: ResponsiveHelper.spacing(context, 16),
              bottom: ResponsiveHelper.spacing(context, 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.sectionHeading ?? "Featured Products",
                  style: AppTextStyles.heading1(
                    context,
                    overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(
                        context,
                        AppDefaults.sectionHeadingSize,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("View all products tapped");
                  },
                  child: Row(
                    children: [
                      Text(
                        "View all",
                        style: AppTextStyles.heading2(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.primary,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Product List (bilkul same)
          SizedBox(
            height: ResponsiveHelper.isMobile(context)
                ? 350
                : (ResponsiveHelper.isTablet(context) ? 380 : 400),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 0,
                    right: index == products.length - 1
                        ? 16
                        : (ResponsiveHelper.isMobile(context)
                        ? 12
                        : (ResponsiveHelper.isTablet(context) ? 14 : 16)),
                  ),
                  child: _buildProductCard(
                    context,
                    product,
                    ResponsiveHelper.isMobile(context),
                    ResponsiveHelper.isTablet(context),
                  ),
                );
              },
            ),
          ),
          ResponsiveHelper.sizedBoxHeight(context, AppDefaults.verticalSpacing),
           CommonDivider(),
        ],
      ),
    );
  }

  // Baki sab code 100% same — koi change nahi
  Widget _buildProductCard(
      BuildContext context,
      Map<String, dynamic> product,
      bool isMobile,
      bool isTablet,
      ) {
    double cardWidth = isMobile ? 240 : (isTablet ? 280 : 320);

    return GestureDetector(
      onTap: () {
        if (_isBottomSheetOpen) return;

        _isBottomSheetOpen = true;
        Future.delayed(const Duration(milliseconds: 250), () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return ProductDetailBottomSheet(product: product);
            },
          );
          _isBottomSheetOpen = false;
        });
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: isMobile ? 180 : (isTablet ? 200 : 220),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_outlined,
                        size: ResponsiveHelper.iconSize(context, 60),
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),

                if (product['badge'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product['badge'].contains('GST')
                            ? Colors.orange[700]
                            : Colors.green[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['badge'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(context, 10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      if (product['badge'] != null && product['badge'].contains('GI'))
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.pink[200]!, width: 2),
                          ),
                          child: Text(
                            'GI',
                            style: TextStyle(
                              color: Colors.pink[700],
                              fontSize: ResponsiveHelper.fontSize(context, 10),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          size: ResponsiveHelper.iconSize(context, 16),
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['description'],
                      style: AppTextStyles.caption(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 11),
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, size: ResponsiveHelper.iconSize(context, 14), color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text('${product['rating']}', style: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12), fontWeight: FontWeight.w600, color: Colors.black87)),
                        const SizedBox(width: 4),
                        Text(product['reviews'], style: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 11), color: Colors.grey[600])),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['price'],
                          style: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 18),
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showVariantBottomSheet(context, product),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.green[700], borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              'Add',
                              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(context, 12), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVariantBottomSheet(BuildContext context, Map<String, dynamic> product) {
    final variants = product['variants'] as List<Map<String, dynamic>>?;
    if (variants == null || variants.isEmpty) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) =>  SingleAddBottomSheet(product: product),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => VariantBottomSheet(product: product),
      );
    }
  }


  List<Map<String, dynamic>> _getProductsData() {
    const String longDescription =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
        'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
        'when an unknown printer took a galley of type and scrambled it to make a type specimen book.';

    return [
      {
        'name': 'Khapli Wheat Atta (Emmer Wheat Flour)',
        'price': '₹2,278',
        'description': longDescription,
        'rating': 4.9,
        'reviews': '2k+ Reviews',
        'image': 'assets/images/product_4.png',
        'badge': 'Best Seller | GI',
        'variants': [
          {
            'size': '10 kg',
            'price': '₹2,278',
            'pricePerUnit': '₹227.8/kg',
            'image': 'assets/images/product_4.png',
          },
          {
            'size': '5 kg',
            'price': '₹1,200',
            'pricePerUnit': '₹240/kg',
            'image': 'assets/images/product_4.png',
          },
        ],
      },
      {
        'name': 'A2 Gir Cow - Cultured Ghee',
        'price': '₹3,370',
        'description': longDescription,
        'rating': 4.9,
        'reviews': '2k+ Reviews',
        'image': 'assets/images/product_5.png',
        'badge': '6% GST OFF',
        'variants': [
          {
            'size': '1000 ml (Glass Bottle)',
            'price': '₹3,370',
            'pricePerUnit': '₹3.37/ml',
            'image': 'assets/images/product_5.png',
          },
          {
            'size': '250 ml (Glass Bottle)',
            'price': '₹935',
            'pricePerUnit': '₹3.74/ml',
            'image': 'assets/images/product_5.png',
          },
          {
            'size': '500 ml (Glass Bottle)',
            'price': '₹1,730',
            'pricePerUnit': '₹3.46/ml',
            'image': 'assets/images/product_5.png',
            'badge': 'GMO Lab Tested',
          },
          {
            'size': '5 litre (Steel Can)',
            'price': '₹15,935',
            'pricePerUnit': '₹3.19/ml',
            'image': 'assets/images/product_5.png',
          },
        ],
      },
      {
        'name': 'Sprouted Ragi Flour - Nachni Satva 500g',
        'price': '₹459',
        'description': longDescription,
        'rating': 4.9,
        'reviews': '295 Reviews',
        'image': 'assets/images/product_6.png',
        'badge': 'Monsoon Picks',
      },
      {
        'name': 'Single Origin Lakadong Turmeric Powder 150g',
        'price': '₹279',
        'description': longDescription,
        'rating': 4.9,
        'reviews': '122 Reviews',
        'image': 'assets/images/product_3.png',
        'badge': 'Monsoon Picks',
      },
      {
        'name': 'Organic Basmati Rice',
        'price': '₹1,299',
        'description': longDescription,
        'rating': 4.8,
        'reviews': '856 Reviews',
        'image': 'assets/images/product_4.png',
        'badge': 'Best Seller',
        'variants': [
          {
            'size': '5 kg',
            'price': '₹1,299',
            'pricePerUnit': '₹259.8/kg',
            'image': 'assets/images/product_4.png',
          },
          {
            'size': '1 kg',
            'price': '₹280',
            'pricePerUnit': '₹280/kg',
            'image': 'assets/images/product_4.png',
          },
        ],
      },
    ];
  }
}