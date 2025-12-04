import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/vendor/products/screen/add_vendor_products_screem.dart';

class VendoeProductListScreen extends StatefulWidget {
  const VendoeProductListScreen({super.key});

  @override
  State<VendoeProductListScreen> createState() =>
      _VendoeProductListScreenState();
}

class _VendoeProductListScreenState extends State<VendoeProductListScreen> {
  // Sample product data
  List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Water Bottle',
      'category': 'Kitchen & Dining',
      'subCategory': 'Bottles',
      'image':
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400',
      'unitPrice': 100.00,
      'purchasePrice': 150.00,
      'hasGST': true,
      'isPublished': true,
      'createdAt': '8 Sep 2021 08:44 PM',
    },
    {
      'id': 2,
      'name': 'Coffee Mug',
      'category': 'Kitchen & Dining',
      'subCategory': 'Drinkware',
      'image':
          'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=400',
      'unitPrice': 80.00,
      'purchasePrice': 120.00,
      'hasGST': true,
      'isPublished': false,
      'createdAt': '10 Sep 2021 10:30 AM',
    },
  ];

  int notificationCount = 1;

  void _togglePublishStatus(int index) {
    setState(() {
      products[index]['isPublished'] = !products[index]['isPublished'];
    });

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          products[index]['isPublished']
              ? '${products[index]['name']} published successfully!'
              : '${products[index]['name']} unpublished!',
        ),
        duration: Duration(seconds: 2),
        backgroundColor: products[index]['isPublished']
            ? Colors.green
            : Colors.orange,
      ),
    );
  }

  void _editProduct(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${products[index]['name']}'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Product',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 14),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        content: Text(
          'Are you sure you want to delete ${products[index]['name']}?',
          style: AppTextStyles.caption(
            context,
            overrideStyle: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  color: AppColors.primary,
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                products.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Product deleted successfully!',
                    style: AppTextStyles.heading2(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Delete',
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  color: Colors.red,
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bulkUpload() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bulk Upload Screen'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _downloadDemoSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading demo sheet...'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewAllProducts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View All Products Screen'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Support Chat'), duration: Duration(seconds: 1)),
    );
  }

  void _openNotifications() {
    setState(() {
      notificationCount = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notifications'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Products',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              color: Colors.teal.shade800,
              fontSize: ResponsiveHelper.fontSize(context, 16),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.support_agent, color: Colors.teal.shade700),
            onPressed: _openSupport,
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.teal.shade700),
                onPressed: _openNotifications,
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: ResponsiveHelper.containerHeight(context, 14),
                      minHeight: ResponsiveHelper.containerHeight(context, 14),
                    ),
                    child: Text(
                      '$notificationCount',
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(context, 8),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          ResponsiveHelper.sizedBoxWidth(context, 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveHelper.sizedBoxHeight(context, 14),

            // Action Cards Section
            Padding(
              padding: ResponsiveHelper.paddingSymmetric(
                context,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.add_shopping_cart,
                      iconColor: Colors.cyan,
                      title: 'Add New\nProducts',
                      onTap: () {
                        // AddVendorProductScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddVendorProductScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  ResponsiveHelper.sizedBoxWidth(context, 14),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.cloud_upload,
                      iconColor: Colors.blue,
                      title: 'Bulk Upload\nProducts',
                      onTap: _bulkUpload,
                    ),
                  ),
                ],
              ),
            ),

            // ResponsiveHelper.sizedBoxHeight(context, 14),
            // // Download Demo Sheet Card
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: _buildDownloadCard(
            //     icon: Icons.file_download,
            //     iconColor: Colors.orange,
            //     sheetIcon: Icons.table_chart,
            //     sheetColor: Colors.green,
            //     title: 'Download Demo Sheet',
            //     onTap: _downloadDemoSheet,
            //   ),
            // ),
            ResponsiveHelper.sizedBoxHeight(context, 20),

            // Products List Header
            Container(
              color: Colors.white,
              padding: ResponsiveHelper.paddingSymmetric(
                context,
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Products List',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.teal.shade600,
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _viewAllProducts,
                    child: Text(
                      'See All Products',
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          color: Colors.teal.shade600,
                          fontSize: ResponsiveHelper.fontSize(context, 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  color: Colors.white,
                  margin: ResponsiveHelper.paddingOnly(context, bottom: 8),
                  padding: ResponsiveHelper.paddingAll(context, 16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ResponsiveHelper.containerWidth(context, 70),
                            height: ResponsiveHelper.containerHeight(
                              context,
                              70,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image,
                                    size: ResponsiveHelper.iconSize(
                                      context,
                                      40,
                                    ),
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                          ResponsiveHelper.sizedBoxWidth(context, 10),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
                                    ),
                                  ),
                                ),
                                ResponsiveHelper.sizedBoxHeight(context, 0),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        product['category'],
                                        style: AppTextStyles.caption(
                                          context,
                                          overrideStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              10,
                                            ),
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      ' > ',
                                      style: AppTextStyles.caption(
                                        context,
                                        overrideStyle: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ResponsiveHelper.fontSize(
                                            context,
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        product['subCategory'],
                                        style: AppTextStyles.caption(
                                          context,
                                          overrideStyle: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              10,
                                            ),
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                ResponsiveHelper.sizedBoxHeight(context, 6),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 4,
                                  children: [
                                    _buildPriceTag(
                                      'Unit Price',
                                      '₹${product['unitPrice'].toStringAsFixed(2)}',
                                    ),
                                    _buildPriceTag(
                                      'Purchase Price',
                                      '₹${product['purchasePrice'].toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ResponsiveHelper.sizedBoxHeight(context, 10),
                      Divider(height: 1, color: Colors.grey.shade300),
                      ResponsiveHelper.sizedBoxHeight(context, 10),
                      // Bottom Row
                      Row(
                        children: [
                          // Toggle Switch
                          Expanded(
                            child: Column(
                              children: [
                                Transform.scale(
                                  scale: 0.85,
                                  child: Switch(
                                    value: product['isPublished'],
                                    onChanged: (value) =>
                                        _togglePublishStatus(index),
                                    activeThumbColor: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product['isPublished']
                                      ? 'Published'
                                      : 'Unpublished',
                                  style: AppTextStyles.body1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: product['isPublished']
                                          ? Colors.green.shade700
                                          : Colors.grey.shade600,
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ResponsiveHelper.sizedBoxWidth(context, 8),

                          // Created At
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Created At',
                                  style: AppTextStyles.body1(
                                    context,
                                    overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        10,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product['createdAt'],
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action Buttons
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.teal.shade700),
                            onPressed: () => _editProduct(index),
                            tooltip: 'Edit Product',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade400,
                            ),
                            onPressed: () => _deleteProduct(index),
                            tooltip: 'Delete Product',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            ResponsiveHelper.sizedBoxHeight(context, 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: ResponsiveHelper.paddingSymmetric(context, vertical: 24),
          child: Column(
            children: [
              Container(
                width: ResponsiveHelper.containerWidth(context, 60),
                height: ResponsiveHelper.containerHeight(context, 60),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      icon == Icons.add_shopping_cart
                          ? Icons.add
                          : Icons.cloud_upload,
                      color: iconColor,
                      size: 32,
                    ),
                  ],
                ),
              ),
              ResponsiveHelper.sizedBoxHeight(context, 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    color: Colors.teal.shade800,
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadCard({
    required IconData icon,
    required Color iconColor,
    required IconData sheetIcon,
    required Color sheetColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: ResponsiveHelper.paddingSymmetric(context, vertical: 24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: ResponsiveHelper.containerWidth(context, 60),
                    height: ResponsiveHelper.containerHeight(context, 60),
                    decoration: BoxDecoration(
                      color: sheetColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      sheetIcon,
                      color: sheetColor,
                      size: ResponsiveHelper.iconSize(context, 30),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      width: ResponsiveHelper.containerWidth(context, 24),
                      height: ResponsiveHelper.containerHeight(context, 24),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(context, 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    color: Colors.teal.shade800,
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceTag(String label, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 8),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              color: Colors.orange,
              fontSize: ResponsiveHelper.fontSize(context, 12),
            ),
          ),
        ),
      ],
    );
  }
}
