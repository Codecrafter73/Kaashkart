import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/constants/app_defaults.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/home/components/single_add_bottomsheet_widget.dart';
import 'package:kaashtkart/features/customer/screen/product/product_detail_bottom_sheet_widget.dart';


class WishlistProductSection extends StatefulWidget {
  final String? sectionHeading;

  const WishlistProductSection({super.key, this.sectionHeading});

  @override
  State<WishlistProductSection> createState() => _WishlistProductSectionState();
}

class _WishlistProductSectionState extends State<WishlistProductSection> {
  bool _isBottomSheetOpen = false;
  final Set<int> _favoriteProducts = {}; // Track favorite products

  @override
  Widget build(BuildContext context) {
    final products = _getProductsData();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Padding(
              padding: ResponsiveHelper.paddingSymmetric(
                context,
                vertical: ResponsiveHelper.spacing(context, 16),
                horizontal: ResponsiveHelper.spacing(context, 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.sectionHeading ?? "My Wishlist",
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
                      print("View all wishlist tapped");
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

            // Grid Product List
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.spacing(context, 16),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: ResponsiveHelper.isMobile(context) ? 12 : 16,
                  mainAxisSpacing: ResponsiveHelper.isMobile(context) ? 12 : 16,
                  childAspectRatio: ResponsiveHelper.isMobile(context)
                      ? 0.68
                      : (ResponsiveHelper.isTablet(context) ? 0.72 : 0.75),
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(
                    context,
                    product,
                    index,
                    ResponsiveHelper.isMobile(context),
                    ResponsiveHelper.isTablet(context),
                  );
                },
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context,
      Map<String, dynamic> product,
      int index,
      bool isMobile,
      bool isTablet,
      ) {
    final isFavorite = _favoriteProducts.contains(index);

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
            // Product Image & Badges
            Stack(
              children: [
                Container(
                  height: isMobile ? 140 : (isTablet ? 160 : 180),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_outlined,
                        size: ResponsiveHelper.iconSize(context, 50),
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),

                // Top Left Badge
                if (product['badge'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: product['badge'].contains('GST')
                            ? Colors.orange[700]
                            : Colors.green[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['badge'].length > 12
                            ? product['badge'].substring(0, 12)
                            : product['badge'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(context, 9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Top Right Icons
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      if (product['badge'] != null &&
                          product['badge'].contains('GI'))
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.pink[200]!,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'GI',
                            style: TextStyle(
                              color: Colors.pink[700],
                              fontSize: ResponsiveHelper.fontSize(context, 9),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isFavorite) {
                              _favoriteProducts.remove(index);
                            } else {
                              _favoriteProducts.add(index);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: ResponsiveHelper.iconSize(context, 14),
                            color: isFavorite ? Colors.red : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      product['name'],
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 13),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: ResponsiveHelper.iconSize(context, 13),
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${product['rating']}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 11),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            product['reviews'],
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 10),
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            product['price'],
                            style: AppTextStyles.heading1(
                              context,
                              overrideStyle: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 16),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showVariantBottomSheet(context, product);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  11,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
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

  void _showVariantBottomSheet(
      BuildContext context,
      Map<String, dynamic> product,
      ) {
    final variants = product['variants'] as List<Map<String, dynamic>>?;
    if (variants == null || variants.isEmpty) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SingleAddBottomSheet(product: product),
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