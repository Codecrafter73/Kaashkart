import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_controller.dart';
import 'package:kaashtkart/features/customer/screen/customer/cart/model/cart_item_model.dart';
import 'package:kaashtkart/features/customer/screen/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatelessWidget {
  final bool showBackButton;

  const CartScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        )
            : null,
        title: Text(
          'My Cart',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () => _showClearCartDialog(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildCartList(cart, context),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              _buildBottomSection(context, cart),
            ],
          );
        },
      ),
    );
  }

  // Empty Cart UI
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text('Add items to get started', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Start Shopping', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // Cart Items List
  Widget _buildCartList(CartProvider cart, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return _buildCartItem(context, item, cart);
      },
    );
  }

  // Premium Cart Item Card (Same Design as Before)
  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.grey[100]!, Colors.grey[50]!]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(Icons.image_outlined, size: 45, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(width: 14),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
                      ),
                      const SizedBox(height: 6),

                      // Size Chip (Same as Home Screen)
                      if (item.size.isNotEmpty && item.size != 'Standard')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[300]!, width: 1.2),
                          ),
                          child: Text(
                            item.size,
                            style: TextStyle(fontSize: 13, color: Colors.green[800], fontWeight: FontWeight.w700),
                          ),
                        ),

                      // Badge
                      if (item.badge != null && item.badge!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.badge!.contains('GST') ? Colors.orange[100] : Colors.green[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.badge!,
                            style: TextStyle(
                              fontSize: 10,
                              color: item.badge!.contains('GST') ? Colors.orange[900] : Colors.green[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Price
                      Row(
                        children: [
                          Text('₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.green[700])),
                          Text(
                            item.price.toStringAsFixed(0),
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Delete Button
                GestureDetector(
                  onTap: () {
                    cart.removeItem(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Item removed'),
                        backgroundColor: Colors.red[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.delete_outline_rounded, color: Colors.red[700], size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity', style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[700]!, width: 1.8),
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.12), blurRadius: 6)],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => cart.decreaseQuantity(item.id),
                        child: Padding(padding: const EdgeInsets.all(10), child: Icon(Icons.remove, color: Colors.green[700], size: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${item.quantity}',
                          style: TextStyle(color: Colors.green[700], fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cart.increaseQuantity(item.id),
                        child: Padding(padding: const EdgeInsets.all(10), child: Icon(Icons.add, color: Colors.green[700], size: 20)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Section - Price Details + Checkout
  Widget _buildBottomSection(BuildContext context, CartProvider cart) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Details (${cart.totalItems} Items)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildPriceRow('Total MRP', '₹${cart.totalMRP.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                _buildPriceRow('Coupon Discount', '- ₹0', color: Colors.green[700]),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Fee', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Row(
                      children: [
                        if (cart.deliveryFee > 0)
                          Text('₹${cart.deliveryFee.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        if (cart.deliveryFee > 0) const SizedBox(width: 6),
                        Text(
                          cart.deliveryFee == 0 ? 'Free' : 'Free',
                          style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildPriceRow(
                  'Total Amount',
                  '₹${cart.totalAmount.toStringAsFixed(0)}',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CustomButton(
                text: "Proceed to Checkout",
                iconData: Icons.arrow_forward,
                iconPosition: IconPosition.right,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(
          value,
          style: TextStyle(fontSize: fontSize ?? 14, fontWeight: fontWeight ?? FontWeight.w600, color: color ?? Colors.black87),
        ),
      ],
    );
  }

  // Clear Cart Dialog
  void _showClearCartDialog(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Are you sure you want to remove all items from cart?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await cart.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared'), backgroundColor: Colors.red),
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red[600])),
          ),
        ],
      ),
    );
  }
}