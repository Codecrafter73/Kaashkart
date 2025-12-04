import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int currentStep = 0;
  String selectedShipping = 'FedEx Express';
  double shippingFee = 12.00;
  String selectedPaymentMethod = 'VISA';
  String selectedPaymentLast4 = '8979';
  bool promoApplied = true;
  String promoCode = '#4RT345';
  double discountPercent = 10.0;

  // Sample cart items from the grocery products
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Khapli Wheat Atta (Emmer Wheat Flour)',
      'price': 2278.0,
      'image': 'assets/images/product_4.png',
      'variant': '10 kg',
      'rating': 4.9,
      'store': 'Kaashtkart Store',
      'quantity': 1,
    },
    {
      'name': 'A2 Gir Cow - Cultured Ghee',
      'price': 3370.0,
      'image': 'assets/images/product_5.png',
      'variant': '1000 ml (Glass Bottle)',
      'rating': 4.9,
      'store': 'Kaashtkart Store',
      'quantity': 1,
    },
  ];

  // Shipping options
  final List<Map<String, dynamic>> shippingOptions = [
    {
      'name': 'FedEx Express',
      'days': '7-8 days',
      'fee': 12.00,
    },
    {
      'name': 'DHL Express',
      'days': '5-6 days',
      'fee': 18.00,
    },
    {
      'name': 'Standard Delivery',
      'days': '10-12 days',
      'fee': 8.00,
    },
  ];

  // Payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'VISA', 'last4': '8979'},
    {'name': 'Mastercard', 'last4': '4532'},
    {'name': 'American Express', 'last4': '7890'},
  ];

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double get discount {
    return promoApplied ? (subtotal * discountPercent / 100) : 0.0;
  }

  double get total {
    return subtotal + shippingFee - discount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              _showExitDialog(context),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: currentStep == 0
            ? _buildFirstScreen(context)
            : _buildSecondScreen(context),
      ),
    );
  }


  Future<bool> _showExitDialog(BuildContext context) async {
    bool exitConfirmed = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                "Exit Checkout",
                style: AppTextStyles.heading1(context,
                    overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16))),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to leave the checkout page? Your progress will be lost.",
            style: AppTextStyles.heading2(context,
                overrideStyle: TextStyle(
                    color: AppColors.txtGreyColor,
                    fontSize: ResponsiveHelper.fontSize(context, 12))),
          ),
          actions: [
            TextButton(
              onPressed: () {
                exitConfirmed = false;
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                exitConfirmed = true;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
    return exitConfirmed;
  }
  // ========== FIRST SCREEN (Delivery Address + Shopping List) ==========
  Widget _buildFirstScreen(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.paddingAll(context, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Section
                _buildDeliveryAddress(context),

                ResponsiveHelper.sizedBoxHeight(context, 24),

                // Shopping List Section
                Text(
                  'Shopping List',
                  style: AppTextStyles.heading2(context,
                      overrideStyle: const TextStyle(fontWeight: FontWeight.w600)),
                ),

                ResponsiveHelper.sizedBoxHeight(context, 16),

                // Cart Items
                ...cartItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return Column(
                    children: [
                      _buildCartItem(
                        context,
                        item: item,
                        index: index,
                      ),
                      ResponsiveHelper.sizedBoxHeight(context, 12),
                      _buildTotalRow(
                        context,
                        'Total Order (${item['quantity']}):',
                        '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                      ),
                      if (index < cartItems.length - 1)
                        ResponsiveHelper.sizedBoxHeight(context, 20),
                    ],
                  );
                }),

                ResponsiveHelper.sizedBoxHeight(context, 20),
              ],
            ),
          ),
        ),

        // Bottom Button
        _buildNextButton(context),
      ],
    );
  }

  // ========== SECOND SCREEN (Payment Details) ==========
  Widget _buildSecondScreen(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.paddingAll(context, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shopping Options
                _buildSectionHeader(
                    context, Icons.local_shipping_outlined, 'Shopping Options'),
                ResponsiveHelper.sizedBoxHeight(context, 12),
                _buildShippingOption(context),

                ResponsiveHelper.sizedBoxHeight(context, 24),

                // Voucher and Promo
                _buildSectionHeader(
                    context, Icons.local_offer_outlined, 'Voucher and Promo'),
                ResponsiveHelper.sizedBoxHeight(context, 12),
                _buildPromoCode(context),

                ResponsiveHelper.sizedBoxHeight(context, 24),

                // Payment Method
                _buildSectionHeader(
                    context, Icons.payment_outlined, 'Payment Method'),
                ResponsiveHelper.sizedBoxHeight(context, 12),
                _buildPaymentMethod(context),

                ResponsiveHelper.sizedBoxHeight(context, 32),

                // Price Breakdown
                _buildPriceBreakdown(context),

                ResponsiveHelper.sizedBoxHeight(context, 20),
              ],
            ),
          ),
        ),

        // Pay Now Button
        _buildPayNowButton(context),
      ],
    );
  }

  // ========== DELIVERY ADDRESS ==========
  Widget _buildDeliveryAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: ResponsiveHelper.iconSize(context, 20),
              color: Colors.black87,
            ),
            ResponsiveHelper.sizedBoxWidth(context, 8),
            Text(
              'Delivery Address',
              style: AppTextStyles.heading2(context,
                  overrideStyle: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),

        ResponsiveHelper.sizedBoxHeight(context, 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: ResponsiveHelper.paddingAll(context, 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Address',
                          style: AppTextStyles.body2(context,
                              overrideStyle:
                              TextStyle(color: Colors.grey[600])),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showEditAddressDialog(context);
                          },
                          child: Icon(
                            Icons.edit_outlined,
                            size: ResponsiveHelper.iconSize(context, 18),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 8),
                    Text(
                      'Chris Hemsworth',
                      style: AppTextStyles.body1(context,
                          overrideStyle:
                          const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 4),
                    Text(
                      'H: B-66, West street, Pennsylvania,\nUSA.',
                      style: AppTextStyles.body2(context,
                          overrideStyle: TextStyle(color: Colors.grey[700])),
                    ),
                    ResponsiveHelper.sizedBoxHeight(context, 4),
                    Text(
                      'Mobile: +96-012 3445 44',
                      style: AppTextStyles.body2(context,
                          overrideStyle: TextStyle(color: Colors.grey[700])),
                    ),
                  ],
                ),
              ),
            ),
            ResponsiveHelper.sizedBoxWidth(context, 12),
            GestureDetector(
              onTap: () {
                _showAddAddressDialog(context);
              },
              child: Container(
                width: ResponsiveHelper.containerWidth(context, 50),
                height: ResponsiveHelper.containerHeight(context, 50),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
                ),
                child: Icon(
                  Icons.add,
                  size: ResponsiveHelper.iconSize(context, 24),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== CART ITEM ==========
  Widget _buildCartItem(
      BuildContext context, {
        required Map<String, dynamic> item,
        required int index,
      }) {
    return Container(
      padding: ResponsiveHelper.paddingAll(context, 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: ResponsiveHelper.containerWidth(context, 80),
            height: ResponsiveHelper.containerHeight(context, 80),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: ResponsiveHelper.borderRadiusAll(context, 8),
            ),
            child: ClipRRect(
              borderRadius: ResponsiveHelper.borderRadiusAll(context, 8),
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.shopping_bag,
                      size: ResponsiveHelper.iconSize(context, 40),
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),

          ResponsiveHelper.sizedBoxWidth(context, 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: AppTextStyles.body1(context,
                      overrideStyle:
                      const TextStyle(fontWeight: FontWeight.w600)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveHelper.sizedBoxHeight(context, 4),
                Text(
                  'Variant: ${item['variant']}',
                  style: AppTextStyles.caption(context,
                      overrideStyle: TextStyle(color: Colors.grey[600])),
                ),
                ResponsiveHelper.sizedBoxHeight(context, 6),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: ResponsiveHelper.iconSize(context, 14),
                      color: Colors.amber,
                    ),
                    ResponsiveHelper.sizedBoxWidth(context, 4),
                    Text(
                      item['rating'].toString(),
                      style: AppTextStyles.caption(context),
                    ),
                    ResponsiveHelper.sizedBoxWidth(context, 12),
                    Icon(
                      Icons.storefront,
                      size: ResponsiveHelper.iconSize(context, 14),
                      color: Colors.grey[600],
                    ),
                    ResponsiveHelper.sizedBoxWidth(context, 4),
                    Expanded(
                      child: Text(
                        item['store'],
                        style: AppTextStyles.caption(context,
                            overrideStyle:
                            TextStyle(color: Colors.grey[600])),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                ResponsiveHelper.sizedBoxHeight(context, 8),
                Row(
                  children: [
                    Text(
                      '₹${item['price'].toStringAsFixed(2)}',
                      style: AppTextStyles.body1(context,
                          overrideStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          )),
                    ),
                    const Spacer(),
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius:
                        ResponsiveHelper.borderRadiusAll(context, 6),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (item['quantity'] > 1) {
                                setState(() {
                                  item['quantity']--;
                                });
                              }
                            },
                            child: Container(
                              padding:
                              ResponsiveHelper.paddingAll(context, 4),
                              child: Icon(
                                Icons.remove,
                                size: ResponsiveHelper.iconSize(context, 16),
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            padding: ResponsiveHelper.paddingSymmetric(
                              context,
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              '${item['quantity']}',
                              style: AppTextStyles.body2(context,
                                  overrideStyle: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                item['quantity']++;
                              });
                            },
                            child: Container(
                              padding:
                              ResponsiveHelper.paddingAll(context, 4),
                              child: Icon(
                                Icons.add,
                                size: ResponsiveHelper.iconSize(context, 16),
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== TOTAL ROW ==========
  Widget _buildTotalRow(BuildContext context, String label, String amount) {
    return Padding(
      padding: ResponsiveHelper.paddingSymmetric(context, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body1(context,
                overrideStyle: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Text(
            amount,
            style: AppTextStyles.body1(context,
                overrideStyle: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ========== SECTION HEADER ==========
  Widget _buildSectionHeader(
      BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.iconSize(context, 22),
          color: Colors.black87,
        ),
        ResponsiveHelper.sizedBoxWidth(context, 8),
        Text(
          title,
          style: AppTextStyles.heading2(context,
              overrideStyle: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // ========== SHIPPING OPTION ==========
  Widget _buildShippingOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showShippingOptionsDialog(context);
      },
      child: Container(
        padding: ResponsiveHelper.paddingAll(context, 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
        ),
        child: Row(
          children: [
            Container(
              padding: ResponsiveHelper.paddingAll(context, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: ResponsiveHelper.borderRadiusAll(context, 8),
              ),
              child: Icon(
                Icons.local_shipping,
                size: ResponsiveHelper.iconSize(context, 24),
                color: AppColors.primary,
              ),
            ),
            ResponsiveHelper.sizedBoxWidth(context, 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedShipping,
                    style: AppTextStyles.body1(context,
                        overrideStyle:
                        const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  ResponsiveHelper.sizedBoxHeight(context, 2),
                  Text(
                    'Shipped in ${shippingOptions.firstWhere((e) => e['name'] == selectedShipping)['days']}',
                    style: AppTextStyles.caption(context,
                        overrideStyle: TextStyle(color: Colors.grey[600])),
                  ),
                ],
              ),
            ),
            Text(
              '₹${shippingFee.toStringAsFixed(2)}',
              style: AppTextStyles.body1(context,
                  overrideStyle: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ResponsiveHelper.sizedBoxWidth(context, 8),
            Icon(
              Icons.keyboard_arrow_down,
              size: ResponsiveHelper.iconSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }

  // ========== PROMO CODE ==========
  Widget _buildPromoCode(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPromoCodeDialog(context);
      },
      child: Container(
        padding: ResponsiveHelper.paddingAll(context, 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
        ),
        child: Row(
          children: [
            if (promoApplied)
              Container(
                padding: ResponsiveHelper.paddingSymmetric(
                  context,
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: ResponsiveHelper.borderRadiusAll(context, 8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  promoCode,
                  style: AppTextStyles.body2(context,
                      overrideStyle:
                      const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            if (promoApplied) ResponsiveHelper.sizedBoxWidth(context, 12),
            if (promoApplied)
              Container(
                padding: ResponsiveHelper.paddingSymmetric(
                  context,
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: ResponsiveHelper.borderRadiusAll(context, 8),
                ),
                child: Row(
                  children: [
                    Text(
                      'Applied',
                      style: AppTextStyles.body2(context,
                          overrideStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    ResponsiveHelper.sizedBoxWidth(context, 4),
                    Icon(
                      Icons.check_circle,
                      size: ResponsiveHelper.iconSize(context, 16),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            if (!promoApplied)
              Text(
                'Add Promo Code',
                style: AppTextStyles.body1(context,
                    overrideStyle: TextStyle(color: Colors.grey[600])),
              ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down,
              size: ResponsiveHelper.iconSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }

  // ========== PAYMENT METHOD ==========
  Widget _buildPaymentMethod(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPaymentMethodDialog(context);
      },
      child: Container(
        padding: ResponsiveHelper.paddingAll(context, 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Name',
                  style: AppTextStyles.caption(context,
                      overrideStyle: TextStyle(color: Colors.grey[600])),
                ),
                ResponsiveHelper.sizedBoxHeight(context, 4),
                Text(
                  selectedPaymentMethod,
                  style: AppTextStyles.body1(context,
                      overrideStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F71),
                      )),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '**** $selectedPaymentLast4',
              style: AppTextStyles.body1(context,
                  overrideStyle: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            ResponsiveHelper.sizedBoxWidth(context, 8),
            Icon(
              Icons.keyboard_arrow_down,
              size: ResponsiveHelper.iconSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }

  // ========== PRICE BREAKDOWN ==========
  Widget _buildPriceBreakdown(BuildContext context) {
    return Column(
      children: [
        _buildPriceRow(context, 'Sub Total', '₹${subtotal.toStringAsFixed(2)}'),
        ResponsiveHelper.sizedBoxHeight(context, 8),
        _buildPriceRow(
            context, 'Shipping Fee', '₹${shippingFee.toStringAsFixed(2)}'),
        ResponsiveHelper.sizedBoxHeight(context, 8),
        if (promoApplied)
          _buildPriceRow(
              context,
              'Discount (${discountPercent.toStringAsFixed(0)}%)',
              '₹${discount.toStringAsFixed(2)}',
              isDiscount: true),
        if (promoApplied) ResponsiveHelper.sizedBoxHeight(context, 16),
        Divider(color: Colors.grey[300]),
        ResponsiveHelper.sizedBoxHeight(context, 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: AppTextStyles.heading2(context,
                  overrideStyle: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text(
              '₹${total.toStringAsFixed(2)}',
              style: AppTextStyles.heading2(context,
                  overrideStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )),
            ),
          ],
        ),
      ],
    );
  }

  // ========== PRICE ROW ==========
  Widget _buildPriceRow(BuildContext context, String label, String amount,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label :',
          style: AppTextStyles.body2(context,
              overrideStyle: TextStyle(color: Colors.grey[700])),
        ),
        Text(
          amount,
          style: AppTextStyles.body1(context,
              overrideStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDiscount ? Colors.red : Colors.black87,
              )),
        ),
      ],
    );
  }
  // ========== BUTTONS ==========
  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentStep = 1;
        });
      },
      child: Container(
        width: double.infinity,
        padding: ResponsiveHelper.paddingSymmetric(context, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            'Proceed to Payment',
            style: AppTextStyles.body1(context,
                overrideStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildPayNowButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPaymentSuccessDialog(context);
      },
      child: Container(
        width: double.infinity,
        padding: ResponsiveHelper.paddingSymmetric(context, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            'Pay Now - ₹${total.toStringAsFixed(2)}',
            style: AppTextStyles.body1(context,
                overrideStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  // ========== DIALOGS ==========
  void _showEditAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: const Text('Edit address functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: const Text('Add new address functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New address added successfully')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showShippingOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Shipping Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: shippingOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option['name']),
              subtitle: Text('Delivered in ${option['days']} - ₹${option['fee']}'),
              value: option['name'],
              groupValue: selectedShipping,
              onChanged: (value) {
                setState(() {
                  selectedShipping = value!;
                  shippingFee = option['fee'];
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPromoCodeDialog(BuildContext context) {
    final TextEditingController promoController = TextEditingController(text: promoApplied ? promoCode : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Promo Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: promoController,
              decoration: const InputDecoration(
                hintText: 'Enter code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (promoApplied)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          promoApplied = false;
                          promoCode = '';
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Promo code removed')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Remove', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                promoApplied = true;
                promoCode = promoController.text.isEmpty ? '#4RT345' : promoController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Promo code "$promoCode" applied successfully')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: paymentMethods.map((method) {
            return RadioListTile<String>(
              title: Text(method['name']),
              subtitle: Text('**** ${method['last4']}'),
              value: method['name'],
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                  selectedPaymentLast4 = method['last4'];
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}