import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_controller.dart';
import 'package:provider/provider.dart';
import 'home_product_list_section_widget.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailBottomSheet({super.key, required this.product});

  @override
  State<ProductDetailBottomSheet> createState() =>  _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  int currentImageIndex = 0;
  String? selectedVariant;
  Map<int, int> quantities = {}; // ✅ Changed from single quantity to map
// NEW: Favorite state
  bool _isFavorited = false;


  @override
  void initState() {
    super.initState();
    final variants = widget.product['variants'] as List<Map<String, dynamic>>?;
    if (variants != null && variants.isNotEmpty) {
      selectedVariant = variants[0]['size'];
      quantities[0] = 0; // ✅ Initialize first variant with 0
    }
  }

  Map<String, dynamic>? get currentVariant {
    final variants = widget.product['variants'] as List<Map<String, dynamic>>?;
    if (variants == null || selectedVariant == null) return null;
    try {
      return variants.firstWhere((v) => v['size'] == selectedVariant);
    } catch (e) {
      return variants.isNotEmpty ? variants[0] : null;
    }
  }

  int get currentVariantIndex {
    final variants = widget.product['variants'] as List<Map<String, dynamic>>?;
    if (variants == null || selectedVariant == null) return 0;
    return variants.indexWhere((v) => v['size'] == selectedVariant);
  }

  int get currentQuantity {
    final index = currentVariantIndex;
    return quantities[index] ?? 0;
  }

  void _updateQuantity(int change) {
    setState(() {
      final index = currentVariantIndex;
      int currentQty = quantities[index] ?? 0;
      int newQty = currentQty + change;
      if (newQty >= 0) {
        quantities[index] = newQty;
      }
    });
  }

  // Toggle favorite
  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });

    // Optional: Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorited
            ? "Added to Wishlist ❤️"
            : "Removed from Wishlist"),
        duration: Duration(milliseconds: 800),
        backgroundColor: _isFavorited ? Colors.pink[600] : Colors.grey[700],
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO: Save to API / Hive / SharedPreferences
    // Example:
    // await WishlistProvider.of(context).toggle(productId);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveHelper.isMobile(context);
    final variants = widget.product['variants'] as List<Map<String, dynamic>>?;
    final hasVariants = variants != null && variants.isNotEmpty;

    return FractionallySizedBox(
      heightFactor: 0.80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: ResponsiveHelper.paddingSymmetric(
                    context,
                    vertical: 14,
                  ),
                  width: ResponsiveHelper.containerWidth(context, 50),
                  height: ResponsiveHelper.containerWidth(context, 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // ✅ Scroll only inside the content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image carousel
                        Stack(
                          children: [
                            Container(
                              height: ResponsiveHelper.containerHeight(
                                context,
                                250,
                              ),
                              width: double.infinity,
                              color: Colors.grey[50],
                              child: PageView.builder(
                                itemCount: hasVariants ? variants.length : 1,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentImageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  String imageUrl = hasVariants
                                      ? variants[index]['image']
                                      : widget.product['image'];
                                  return Padding(
                                    padding: ResponsiveHelper.paddingAll(
                                      context,
                                      20,
                                    ),
                                    child: Image.asset(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image_outlined,
                                          size: ResponsiveHelper.iconSize(
                                            context,
                                            100,
                                          ),
                                          color: Colors.grey[400],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Share button
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Column(
                                children: [
                                  Container(
                                    padding: ResponsiveHelper.paddingAll(
                                      context,
                                      8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(30),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.share_outlined,
                                      size: ResponsiveHelper.iconSize(
                                        context,
                                        20,
                                      ),
                                    ),
                                  ),
                                  ResponsiveHelper.sizedBoxHeight(context, 10),
                                  // Functional Heart Button
                                  GestureDetector(
                                    onTap: _toggleFavorite, // This makes it work!
                                    child: Container(
                                      padding: ResponsiveHelper.paddingAll(context, 6,),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(30),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 300),
                                        transitionBuilder: (child, animation) =>
                                            ScaleTransition(scale: animation, child: child),
                                        child: Icon(
                                          _isFavorited
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          key: ValueKey<bool>(_isFavorited),
                                          size: ResponsiveHelper.iconSize(context, 20),
                                          color: _isFavorited
                                              ? Colors.red[600]
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Product Info
                        Padding(
                          padding: ResponsiveHelper.paddingAll(context, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product['name'],
                                style: AppTextStyles.heading2(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      16,
                                    ),
                                  ),
                                ),
                              ),

                              ResponsiveHelper.sizedBoxHeight(context, 6),
                              Text(
                                widget.product['description'],
                                style: AppTextStyles.body1(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      12,
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.sizedBoxHeight(context, 10),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < 4
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: ResponsiveHelper.iconSize(
                                          context,
                                          10,
                                        ),
                                        color: Colors.amber[700],
                                      );
                                    }),
                                  ),
                                  ResponsiveHelper.sizedBoxWidth(context, 8),
                                  Text(
                                    '${widget.product['rating']} | ${widget.product['reviews']}',
                                    style: AppTextStyles.body1(
                                      context,
                                      overrideStyle: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ResponsiveHelper.sizedBoxHeight(context, 8),

                              GestureDetector(
                                onTap: () => print("See all reviews tapped"),
                                child: Text(
                                  'See All Reviews',
                                  style: AppTextStyles.body1(
                                    context,
                                    overrideStyle: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.sizedBoxHeight(context, 8),

                              // Variants
                              if (hasVariants) ...[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ✅ Show price on left side
                                    Text(
                                      currentVariant != null
                                          ? currentVariant!['price']
                                          : widget.product['price'],
                                      style: AppTextStyles.heading2(
                                        context,
                                        overrideStyle: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                            context,
                                            20,
                                          ),
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),

                                    // ✅ Right side: selected variant size (clickable)
                                    GestureDetector(
                                      onTap: () {
                                        _showVariantSelector(context, variants);
                                      },
                                      child: Container(
                                        padding:
                                        ResponsiveHelper.paddingSymmetric(
                                          context,
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green[700],
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              selectedVariant ??
                                                  variants[0]['size'],
                                              style: AppTextStyles.heading2(
                                                context,
                                                overrideStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  ResponsiveHelper.fontSize(
                                                    context,
                                                    12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ResponsiveHelper.sizedBoxWidth(
                                              context,
                                              8,
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: ResponsiveHelper.iconSize(
                                                context,
                                                16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                ResponsiveHelper.sizedBoxHeight(context, 16),
                              ],
                              // Member price
                              Container(
                                padding: ResponsiveHelper.paddingSymmetric(
                                  context,
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding:
                                      ResponsiveHelper.paddingSymmetric(
                                        context,
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[700],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'COLLECTIVE',
                                        style: AppTextStyles.heading2(
                                          context,
                                          overrideStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Members Price',
                                      style: AppTextStyles.heading2(
                                        context,
                                        overrideStyle: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                            context,
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹594',
                                      style: AppTextStyles.heading2(
                                        context,
                                        overrideStyle: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                            context,
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ResponsiveHelper.sizedBoxWidth(context, 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: ResponsiveHelper.iconSize(
                                        context,
                                        10,
                                      ),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Similar Products Section
                        Padding(
                          padding: ResponsiveHelper.paddingOnly(
                            context,
                            top: 12,
                            bottom: 24,
                          ),
                          child: HomelProductListSection(
                            sectionHeading: 'Similar Products',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ Fixed Add to Cart bar - UPDATED
                Container(
                  padding: ResponsiveHelper.paddingAll(context, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: currentQuantity == 0
                        ? SizedBox(
                      width: double.infinity,
                      height: ResponsiveHelper.containerHeight(
                        context,
                        40,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _updateQuantity(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.grey[800]!,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add To Cart',
                          style: AppTextStyles.heading2(
                            context,
                            overrideStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(
                                context,
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: ResponsiveHelper.containerHeight(
                              context,
                              40,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _updateQuantity(-1);
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: ResponsiveHelper.iconSize(
                                      context,
                                      22,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$currentQuantity',
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _updateQuantity(1);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: ResponsiveHelper.iconSize(
                                      context,
                                      22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: ResponsiveHelper.containerHeight(
                              context,
                              40,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (currentQuantity > 0) {
                                  final cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  );

                                  // ✅ Use the same method as VariantBottomSheet
                                  await cartProvider.addVariants(
                                    widget.product,
                                    quantities,
                                  );

                                  int totalItems = quantities.values.fold(
                                    0,
                                        (sum, qty) => sum + qty,
                                  );

                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "$totalItems item(s) added to cart",
                                      ),
                                      backgroundColor: Colors.green[700],
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Add to Cart',
                                style: AppTextStyles.heading1(
                                  context,
                                  overrideStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Close button centered at the top
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: ResponsiveHelper.containerWidth(context, 40),
                  height: ResponsiveHelper.containerWidth(context, 40),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    size: ResponsiveHelper.iconSize(context, 22),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVariantSelector(
      BuildContext context,
      List<Map<String, dynamic>> variants,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Size',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...variants.map((variant) {
                bool isSelected = selectedVariant == variant['size'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedVariant = variant['size'];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[50] : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? Colors.green[700]!
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              variant['size'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              variant['pricePerUnit'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          variant['price'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}