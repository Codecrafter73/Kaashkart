import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_controller.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Top Header (Fixed Cart Badge Issue)
          Container(
            color: AppColors.primary,
            padding: ResponsiveHelper.paddingSymmetric(context, horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              top: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white70, width: 2),
                              ),
                              child: Icon(Icons.person_outline, color: AppColors.primary, size: 24),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, Ashish Kumar',
                                    style: AppTextStyles.heading1(context).copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Welcome to Vendor",
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification Icon with Cart Badge (Fixed!)
                      InkWell(
                        onTap: () {},
                        child: Consumer<CartProvider>(
                          builder: (context, cart, child) {
                            final itemCount = cart.totalItems; // ← NAYA: totalItems use kiya
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                                ),
                                if (itemCount > 0) // ← Yahan change kiya
                                  Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        itemCount.toString(), // ← totalItems se count
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Dashboard Body (Baki sab same)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Section
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildStatCard(context, icon: 'Money', value: '₹230.44', label: 'Gross Sales', percentage: '+10%', color: const Color(0xFF4CAF50))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStatCard(context, icon: 'Money Bag', value: '₹6002', label: 'Earnings', percentage: '+5%', color: const Color(0xFF4CAF50))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildStatCard(context, icon: 'Clipboard', value: '1043', label: 'Total Orders', percentage: '+15%', color: const Color(0xFF4CAF50))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStatCard(context, icon: 'Package', value: '107', label: 'Total Products', percentage: '+5%', color: const Color(0xFF4CAF50))),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // New Orders Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('New Order', style: AppTextStyles.heading2(context).copyWith(fontSize: 16)),
                      TextButton(
                        onPressed: () {},
                        child: Text('See All Orders', style: TextStyle(color: AppColors.primary, fontSize: 14)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildOrderCard(
                    context,
                    orderId: '#20211028-07104354',
                    date: '2 Nov 2021 04:24 PM',
                    customerName: 'Ankit Gajjar',
                    status: 'Placed',
                    amount: '₹230.44',
                    icon: 'Document',
                    iconBg: const Color(0xFFE8F5E9),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    context,
                    orderId: '#20211028-07104354',
                    date: '2 Nov 2021 04:24 PM',
                    customerName: 'Ankit Gajjar',
                    status: 'Placed',
                    amount: '₹230.44',
                    icon: 'Plus',
                    iconBg: const Color(0xFFE0F7FA),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String icon, required String value, required String label, required String percentage, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [Text(percentage, style: TextStyle(color: color, fontSize: 12)), Icon(Icons.arrow_upward, size: 14, color: color)]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, {required String orderId, required String date, required String customerName, required String status, required String amount, required String icon, required Color iconBg}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 12),
                const Text('Customer Name', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(customerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Delivery Status', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(status, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
              ],
            ),
          ),
          Column(
            children: [
              Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 12),
              Container(width: 60, height: 60, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(icon, style: const TextStyle(fontSize: 28)))),
            ],
          ),
        ],
      ),
    );
  }




}