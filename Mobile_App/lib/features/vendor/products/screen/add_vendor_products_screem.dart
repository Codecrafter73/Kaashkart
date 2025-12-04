import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/core/utls/custom_text_field_utils.dart';
import 'package:kaashtkart/core/utls/default_common_app_bar.dart';
import 'package:kaashtkart/core/utls/responsive_dropdown_utils.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/core/utls/select_documents_ui_screen.dart';

class ProductVariant {
  String variantName;
  bool isEnabled;
  TextEditingController priceController;
  TextEditingController discountController;
  TextEditingController finalPriceController;
  TextEditingController stockQuantityController;
  bool isPercentDiscount;

  ProductVariant({
    required this.variantName,
    this.isEnabled = false,
  })  : priceController = TextEditingController(text: '0.00'),
        discountController = TextEditingController(text: '0'),
        finalPriceController = TextEditingController(text: 'Auto calculated'),
        stockQuantityController = TextEditingController(),
        isPercentDiscount = true;

  void dispose() {
    priceController.dispose();
    discountController.dispose();
    finalPriceController.dispose();
    stockQuantityController.dispose();
  }
}

class AddVendorProductScreen extends StatefulWidget {
  const AddVendorProductScreen({super.key});

  @override
  State<AddVendorProductScreen> createState() => _AddVendorProductScreenState();
}

class _AddVendorProductScreenState extends State<AddVendorProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for common fields
  final TextEditingController _vendorIdController = TextEditingController(text: 'KKVEN0002');
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown values
  String? selectedCategory;

  // Product Variants
  late List<ProductVariant> variants;

  final List<String> categories = [
    'Kitchen & Dining',
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports & Outdoors',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize variants
    variants = [
      ProductVariant(variantName: '1 Kg', isEnabled: true),
      ProductVariant(variantName: '500 gm'),
      ProductVariant(variantName: '250 gm'),
    ];

    // Add listeners to all variants
    for (var variant in variants) {
      variant.priceController.addListener(() => _calculateFinalPrice(variant));
      variant.discountController.addListener(() => _calculateFinalPrice(variant));
    }
  }

  void _calculateFinalPrice(ProductVariant variant) {
    double price = double.tryParse(variant.priceController.text) ?? 0.0;
    double discount = double.tryParse(variant.discountController.text) ?? 0.0;
    double finalPrice = price;

    if (discount > 0) {
      if (variant.isPercentDiscount) {
        // Percentage discount
        if (discount <= 100) {
          double discountAmount = (price * discount) / 100;
          discountAmount = discountAmount.ceilToDouble();
          finalPrice = price - discountAmount;
        }
      } else {
        // Flat rupee discount
        if (discount <= price) {
          finalPrice = price - discount;
        } else {
          finalPrice = 0.0;
        }
      }
    }

    finalPrice = finalPrice.roundToDouble();
    variant.finalPriceController.text = '₹${finalPrice.toStringAsFixed(0)}';
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // Check if at least one variant is enabled
      bool hasEnabledVariant = variants.any((v) => v.isEnabled);
      if (!hasEnabledVariant) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enable at least one variant'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Collect data from enabled variants
      List<Map<String, dynamic>> variantData = [];
      for (var variant in variants) {
        if (variant.isEnabled) {
          variantData.add({
            'variant': variant.variantName,
            'price': variant.priceController.text,
            'discount': variant.discountController.text,
            'discountType': variant.isPercentDiscount ? 'percent' : 'rupees',
            'finalPrice': variant.finalPriceController.text,
            'stock': variant.stockQuantityController.text,
          });
        }
      }

      print('Product Name: ${_productNameController.text}');
      print('Variants: $variantData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product with ${variantData.length} variant(s) saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _vendorIdController.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    for (var variant in variants) {
      variant.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: DefaultCommonAppBar(activityName: "Add New Product"),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveHelper.paddingAll(context, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveHelper.sizedBoxHeight(context, 8),

                // Product Images
                ProductImagesUploadWidget(
                  productId: "123",
                  allowMultiple: false,
                  title: "Product Main Image",
                  existingImageUrls: [],
                  onImagesSelected: (images) {
                    print("Main image selected: ${images.length}");
                  },
                ),
                ResponsiveHelper.sizedBoxHeight(context, 16),

                ProductImagesUploadWidget(
                  productId: "123",
                  allowMultiple: true,
                  maxImages: 5,
                  title: "Product Gallery (Optional)",
                  existingImageUrls: [],
                  onImagesSelected: (images) {
                    print("Gallery images selected: ${images.length}");
                  },
                ),
                ResponsiveHelper.sizedBoxHeight(context, 16),

                _buildSectionHeader('Basic Information', Icons.info_outline),
                ResponsiveHelper.sizedBoxHeight(context, 12),

                CustomTextField(
                  hintText: 'Vendor ID',
                  title: 'Vendor ID',
                  controller: _vendorIdController,
                  readOnly: true,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                ResponsiveHelper.sizedBoxHeight(context, 4),

                CustomTextField(
                  hintText: 'Enter product name',
                  title: 'Product Name',
                  controller: _productNameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Product name is required' : null,
                ),
                ResponsiveHelper.sizedBoxHeight(context, 4),

                ResponsiveDropdown<String>(
                  value: selectedCategory,
                  itemList: categories,
                  onChanged: (value) => setState(() => selectedCategory = value),
                  hint: 'Choose category...',
                  label: 'Product Category',
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                ResponsiveHelper.sizedBoxHeight(context, 4),

                CustomTextField(
                  hintText: 'Write product description...',
                  title: 'Product Description',
                  controller: _descriptionController,
                  isMultiLine: true,
                  maxLines: 5,
                  minLines: 5,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
                ),
                ResponsiveHelper.sizedBoxHeight(context, 4),

                // Variant Selection Checkboxes
                _buildSectionHeader('Product Variants', Icons.view_list),
                ResponsiveHelper.sizedBoxHeight(context, 12),

                Container(
                  width: double.infinity,
                  padding:ResponsiveHelper.paddingAll(context,12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select variants to add:',
                        style: AppTextStyles.heading2(
                          context,
                          overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 11),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                   ResponsiveHelper.sizedBoxHeight(context, 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: variants.map((variant) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                variant.isEnabled = !variant.isEnabled;
                              });
                            },
                            child: Container(
                              padding: ResponsiveHelper.paddingSymmetric(context,horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: variant.isEnabled
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: variant.isEnabled
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    variant.isEnabled
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: variant.isEnabled
                                        ? AppColors.primary
                                        : Colors.grey,
                                    size: ResponsiveHelper.iconSize(context, 18),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    variant.variantName,
                                    style: AppTextStyles.heading2(
                                      context,
                                      overrideStyle: TextStyle(
                                        color: variant.isEnabled
                                            ? AppColors.primary
                                            : Colors.grey.shade700,
                                        fontWeight: variant.isEnabled
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        fontSize: ResponsiveHelper.fontSize(context, 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                ResponsiveHelper.sizedBoxHeight(context, 20),

                // Variant Details Sections
                ...variants.where((v) => v.isEnabled).map((variant) {
                  return Column(
                    children: [
                      _buildVariantSection(variant),
                      ResponsiveHelper.sizedBoxHeight(context, 16),
                    ],
                  );
                }),

                ResponsiveHelper.sizedBoxHeight(context, 16),
                CustomButton(
                  color: AppColors.primary,
                  text: "Save Product",
                  iconData: Icons.check_circle_outline,
                  height: 40,
                  onPressed: (){
                    _saveProduct();
                  },
                ),

                ResponsiveHelper.sizedBoxHeight(context, 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVariantSection(ProductVariant variant) {
    return Container(
      padding: ResponsiveHelper.paddingAll(context,16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variant Header
          Row(
            children: [
              Container(
                padding:ResponsiveHelper.paddingSymmetric(context,horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  variant.variantName,
                  style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    ),
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red, size: ResponsiveHelper.iconSize(context, 18)),
                onPressed: () {
                  setState(() {
                    variant.isEnabled = false;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),

          Divider(height: 24),

          // Pricing Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price (₹)',
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 10),
                        ),
                      ),
                    ),
                    CustomTextField(
                      hintText: '0.00',
                      controller: variant.priceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              ResponsiveHelper.sizedBoxWidth(context, 12),

              // Discount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.isPercentDiscount ? 'Discount (%)' : 'Discount (₹)',
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 10),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        CustomTextField(
                          hintText: '0',
                          controller: variant.discountController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: variant.isPercentDiscount
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) return null;
                            double? val = double.tryParse(value);
                            if (val == null) return 'Invalid';
                            if (variant.isPercentDiscount && val > 100) return 'Max 100%';
                            if (!variant.isPercentDiscount) {
                              double price = double.tryParse(variant.priceController.text) ?? 0;
                              if (val > price) return 'Exceeds price';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding:ResponsiveHelper.paddingOnly(context,right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                variant.isPercentDiscount = !variant.isPercentDiscount;
                                variant.discountController.clear();
                                _calculateFinalPrice(variant);
                              });
                            },
                            child: Container(
                              padding: ResponsiveHelper.paddingSymmetric(context,horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                variant.isPercentDiscount ? '%' : '₹',
                                style: AppTextStyles.heading1(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(context, 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ResponsiveHelper.sizedBoxWidth(context, 12),

              // Final Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Final Price',
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 10),
                        ),
                      ),
                    ),
                    CustomTextField(
                      hintText: 'Auto',
                      controller: variant.finalPriceController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          ResponsiveHelper.sizedBoxHeight(context, 12),

          // Stock Quantity
          CustomTextField(
            hintText: 'Enter stock quantity',
            title: 'Stock Quantity',
            controller: variant.stockQuantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: ResponsiveHelper.iconSize(context, 16)),
         ResponsiveHelper.sizedBoxWidth(context, 8),
          Text(
            title,
            style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}