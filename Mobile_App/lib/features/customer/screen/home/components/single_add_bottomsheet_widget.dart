import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_controller.dart';
import 'package:provider/provider.dart';

/// Bottom sheet for products WITHOUT variants
class SingleAddBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;

  const SingleAddBottomSheet({super.key, required this.product});

  @override
  State<SingleAddBottomSheet> createState() => _SingleAddBottomSheetState();
}

class _SingleAddBottomSheetState extends State<SingleAddBottomSheet> {
  int quantity = 0;

  void _updateQuantity(int change) {
    setState(() {
      quantity = (quantity + change).clamp(0, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: ResponsiveHelper.paddingAll(context, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: ResponsiveHelper.containerWidth(context, 50),
              height: ResponsiveHelper.containerWidth(context, 4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          ResponsiveHelper.sizedBoxHeight(context, 16),

          // Product Image & Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: ResponsiveHelper.containerWidth(context, 80),
                height: ResponsiveHelper.containerWidth(context, 80),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: ResponsiveHelper.paddingAll(context, 8),
                child: Image.asset(
                  widget.product['image'] ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_outlined,
                      size: ResponsiveHelper.iconSize(context, 40),
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
              ResponsiveHelper.sizedBoxWidth(context, 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['name'] ?? 'Product',
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 4),
                    Text(
                      'Standard Size',
                      style: AppTextStyles.body1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 8),
                    Text(
                      widget.product['price'] ?? '₹0',
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 18),
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ResponsiveHelper.sizedBoxHeight(context, 24),

          // Action Buttons
          quantity == 0
              ? SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.containerHeight(context, 48),
            child: ElevatedButton(
              onPressed: () {
                _updateQuantity(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey[800]!, width: 1),
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
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          )
              : Row(
            children: [
              // Quantity Selector
              Expanded(
                child: Container(
                  height: ResponsiveHelper.containerHeight(context, 48),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => _updateQuantity(-1),
                        icon: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: ResponsiveHelper.iconSize(context, 24),
                        ),
                      ),
                      Text(
                        '$quantity',
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _updateQuantity(1),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: ResponsiveHelper.iconSize(context, 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ResponsiveHelper.sizedBoxWidth(context, 12),

              // Add to Cart Button
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: ResponsiveHelper.containerHeight(context, 48),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (quantity > 0) {
                        final cartProvider = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        // ✅ Extract price properly
                        String priceString = widget.product['price'] ?? '₹0';
                        double price = double.tryParse(
                          priceString.replaceAll('₹', '').replaceAll(',', ''),
                        ) ??
                            0.0;

                        await cartProvider.addSingleProduct({
                          'id': widget.product['id'],
                          'name': widget.product['name'],
                          'image': widget.product['image'],
                          'price': price,
                          'badge': widget.product['badge'],
                        });


                        // Close bottom sheet
                        Navigator.pop(context);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$quantity item(s) added to cart'),
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
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          ResponsiveHelper.sizedBoxHeight(context, 16),
        ],
      ),
    );
  }
}


class VariantBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;

  const VariantBottomSheet({super.key, required this.product});

  @override
  State<VariantBottomSheet> createState() => _VariantBottomSheetState();
}

class _VariantBottomSheetState extends State<VariantBottomSheet> {
  Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();
    final variants = widget.product['variants'] as List<Map<String, dynamic>>?;
    if (variants != null) {
      for (int i = 0; i < variants.length; i++) {
        quantities[i] = 0;
      }
    }
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      int current = quantities[index] ?? 0;
      quantities[index] = (current + change).clamp(0, 99);
      if (quantities[index] == 0) {
        quantities.remove(index); // optional: clean up zero quantities
      }
    });
  }

  int get totalSelectedItems {
    return quantities.values.fold(0, (sum, qty) => sum + qty);
  }

  @override
  Widget build(BuildContext context) {
    final variants = widget.product['variants'] as List<Map<String, dynamic>>? ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Close Button (same as desired design)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: ResponsiveHelper.iconSize(context, 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.product['name'] ?? 'Select Variant',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Variants List (same design as second code)
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              itemBuilder: (context, index) {
                final variant = variants[index];
                final quantity = quantities[index] ?? 0;
                final hasQuantity = quantity > 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasQuantity ? Colors.green[700]! : Colors.grey[200]!,
                      width: hasQuantity ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Variant Image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            Image.asset(
                              variant['image'] ?? widget.product['image'] ?? '',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                            if (variant['badge'] != null)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.verified, size: 12, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Variant Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              variant['size'] ?? 'Standard',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 14),
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              variant['price'] ?? '₹0',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 16),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (variant['pricePerUnit'] != null)
                              Text(
                                variant['pricePerUnit'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(context, 12),
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Add / Quantity Controls
                      if (!hasQuantity)
                        GestureDetector(
                          onTap: () => _updateQuantity(index, 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[800]!, width: 1.5),
                            ),
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 13),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _updateQuantity(index, -1),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.remove, size: 18, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _updateQuantity(index, 1),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.add, size: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Confirm Button (only when items selected)
          if (totalSelectedItems > 0)
            Container(
              padding: const EdgeInsets.all(16),
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
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);

                      // Add each selected variant
                      for (var entry in quantities.entries) {
                        if (entry.value > 0) {
                          final variant = variants[entry.key];
                          String priceStr = variant['price'] ?? '₹0';
                          double price = double.tryParse(
                            priceStr.replaceAll('₹', '').replaceAll(',', ''),
                          ) ?? 0.0;

                          // Add variant multiple times based on quantity
                          for (int i = 0; i < entry.value; i++) {
                            await cartProvider.addSingleProduct({
                              'id': widget.product['id'],
                              'name': widget.product['name'],
                              'image': variant['image'] ?? widget.product['image'],
                              'price': price,
                              'badge': widget.product['badge'],
                              'size': variant['size'],
                            });
                          }
                        }
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$totalSelectedItems item(s) added to cart'),
                          backgroundColor: Colors.green[700],
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}