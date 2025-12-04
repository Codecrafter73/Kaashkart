import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/default_common_app_bar.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/home/components/single_add_bottomsheet_widget.dart';


class CategoryListScreen extends StatefulWidget {
  final bool showBackButton;

  const CategoryListScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Fresh Fruits",
      "icon": "🍎",
      "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
      "items": [
        {
          "name": "Red Apple",
          "icon": "🍎",
          "price": "₹180",
          "unit": "1 kg",
          "rating": 4.8,
          "reviews": "2.5k",
          "description": "Fresh, crisp red apples rich in fiber and vitamin C",
          "badge": "Bestseller",
          "image": "assets/images/product_4.png",
          "variants": [
            {"size": "500 g", "price": "₹95", "pricePerUnit": "₹190/kg"},
            {"size": "1 kg", "price": "₹180", "pricePerUnit": "₹180/kg"},
            {"size": "2 kg", "price": "₹340", "pricePerUnit": "₹170/kg"},
          ]
        },
        {
          "name": "Banana",
          "icon": "🍌",
          "price": "₹50",
          "unit": "1 dozen",
          "rating": 4.7,
          "reviews": "3.2k",
          "description": "Fresh ripe bananas packed with potassium and energy",
          "badge": "Fresh",
          "image": "assets/images/product_5.png",
        },
        {
          "name": "Orange",
          "icon": "🍊",
          "price": "₹120",
          "unit": "1 kg",
          "rating": 4.6,
          "reviews": "1.8k",
          "description": "Juicy oranges loaded with vitamin C",
          "image": "assets/images/product_6.png",
          "variants": [
            {"size": "500 g", "price": "₹65", "pricePerUnit": "₹130/kg"},
            {"size": "1 kg", "price": "₹120", "pricePerUnit": "₹120/kg"},
          ]
        },
        {
          "name": "Pomegranate",
          "icon": "🍇",
          "price": "₹280",
          "unit": "1 kg",
          "rating": 4.9,
          "reviews": "2k",
          "description": "Premium quality pomegranates with sweet ruby red arils",
          "badge": "Premium",
          "image": "assets/images/product_3.png",
        },
        {
          "name": "Papaya",
          "icon": "🥭",
          "price": "₹60",
          "unit": "1 kg",
          "rating": 4.5,
          "reviews": "950",
          "description": "Ripe and sweet papaya perfect for breakfast",
          "image": "assets/images/product_4.png",
        },
        {
          "name": "Grapes Green",
          "icon": "🍇",
          "price": "₹90",
          "unit": "500 g",
          "rating": 4.7,
          "reviews": "1.5k",
          "description": "Seedless green grapes, sweet and crunchy",
          "image": "assets/images/product_5.png",
        },
      ]
    },
    {
      "name": "Seasonal Fruits",
      "icon": "☀️",
      "gradient": [Color(0xFFFFA726), Color(0xFFFFD54F)],
      "items": [
        {
          "name": "Alphonso Mango",
          "icon": "🥭",
          "price": "₹450",
          "unit": "1 kg",
          "rating": 5.0,
          "reviews": "5k+",
          "description": "King of mangoes - Authentic Alphonso from Ratnagiri",
          "badge": "GI Tag",
          "image": "assets/images/product_6.png",
          "variants": [
            {"size": "500 g", "price": "₹240", "pricePerUnit": "₹480/kg"},
            {"size": "1 kg", "price": "₹450", "pricePerUnit": "₹450/kg"},
            {"size": "3 kg Box", "price": "₹1,299", "pricePerUnit": "₹433/kg"},
          ]
        },
        {
          "name": "Watermelon",
          "icon": "🍉",
          "price": "₹40",
          "unit": "1 kg",
          "rating": 4.6,
          "reviews": "2.8k",
          "description": "Sweet and refreshing summer watermelon",
          "image": "assets/images/product_3.png",
        },
        {
          "name": "Strawberry",
          "icon": "🍓",
          "price": "₹320",
          "unit": "250 g",
          "rating": 4.8,
          "reviews": "1.2k",
          "description": "Fresh Mahabaleshwar strawberries",
          "badge": "Premium",
          "image": "assets/images/product_4.png",
        },
        {
          "name": "Custard Apple",
          "icon": "🍈",
          "price": "₹180",
          "unit": "1 kg",
          "rating": 4.7,
          "reviews": "890",
          "description": "Creamy sweet custard apples",
          "image": "assets/images/product_5.png",
        },
      ]
    },
    {
      "name": "Exotic Fruits",
      "icon": "🌍",
      "gradient": [Color(0xFF42A5F5), Color(0xFF66BB6A)],
      "items": [
        {
          "name": "Avocado",
          "icon": "🥑",
          "price": "₹180",
          "unit": "1 piece",
          "rating": 4.7,
          "reviews": "980",
          "description": "Fresh imported avocados rich in healthy fats",
          "badge": "Imported",
          "image": "assets/images/product_6.png",
        },
        {
          "name": "Dragon Fruit",
          "icon": "🐉",
          "price": "₹120",
          "unit": "1 piece",
          "rating": 4.8,
          "reviews": "1.1k",
          "description": "Exotic dragon fruit with vibrant color",
          "image": "assets/images/product_3.png",
        },
        {
          "name": "Blueberries",
          "icon": "🫐",
          "price": "₹499",
          "unit": "125 g",
          "rating": 4.9,
          "reviews": "750",
          "description": "Fresh blueberries packed with antioxidants",
          "badge": "Premium",
          "image": "assets/images/product_4.png",
        },
        {
          "name": "Kiwi",
          "icon": "🥝",
          "price": "₹199",
          "unit": "3 pieces",
          "rating": 4.6,
          "reviews": "650",
          "description": "Tangy and sweet kiwi fruit",
          "image": "assets/images/product_5.png",
        },
      ]
    },
    {
      "name": "Dry Fruits",
      "icon": "🌰",
      "gradient": [Color(0xFF8D6E63), Color(0xFFBCAAA4)],
      "items": [
        {
          "name": "Premium Almonds",
          "icon": "🌰",
          "price": "₹899",
          "unit": "500 g",
          "rating": 4.9,
          "reviews": "3.5k",
          "description": "California almonds - Rich in protein and healthy fats",
          "badge": "Premium",
          "image": "assets/images/product_6.png",
          "variants": [
            {"size": "250 g", "price": "₹470", "pricePerUnit": "₹1,880/kg"},
            {"size": "500 g", "price": "₹899", "pricePerUnit": "₹1,798/kg"},
            {"size": "1 kg", "price": "₹1,699", "pricePerUnit": "₹1,699/kg"},
          ]
        },
        {
          "name": "Cashews W320",
          "icon": "🥜",
          "price": "₹1,099",
          "unit": "500 g",
          "rating": 4.8,
          "reviews": "2.9k",
          "description": "Premium quality whole cashews",
          "image": "assets/images/product_3.png",
        },
        {
          "name": "Walnuts",
          "icon": "🌰",
          "price": "₹1,299",
          "unit": "500 g",
          "rating": 4.9,
          "reviews": "2.1k",
          "description": "Kashmiri walnuts with brain-healthy omega-3",
          "image": "assets/images/product_4.png",
        },
        {
          "name": "Dates (Khajoor)",
          "icon": "🍂",
          "price": "₹399",
          "unit": "500 g",
          "rating": 4.7,
          "reviews": "2.4k",
          "description": "Natural sweetness packed with energy",
          "image": "assets/images/product_5.png",
        },
      ]
    },
    {
      "name": "Cut Fruits",
      "icon": "🔪",
      "gradient": [Color(0xFFEC407A), Color(0xFFAB47BC)],
      "items": [
        {
          "name": "Fresh Fruit Mix",
          "icon": "🍉🍎🍊",
          "price": "₹149",
          "unit": "500 g",
          "rating": 4.6,
          "reviews": "1.3k",
          "description": "Ready-to-eat mixed fruit platter",
          "badge": "Fresh Cut",
          "image": "assets/images/product_6.png",
        },
        {
          "name": "Cut Papaya",
          "icon": "🥭",
          "price": "₹79",
          "unit": "400 g",
          "rating": 4.5,
          "reviews": "890",
          "description": "Freshly cut papaya cubes",
          "image": "assets/images/product_3.png",
        },
        {
          "name": "Cut Pineapple",
          "icon": "🍍",
          "price": "₹99",
          "unit": "400 g",
          "rating": 4.7,
          "reviews": "1.1k",
          "description": "Sweet pineapple chunks ready to eat",
          "image": "assets/images/product_4.png",
        },
        {
          "name": "Melon Cubes",
          "icon": "🍈",
          "price": "₹89",
          "unit": "500 g",
          "rating": 4.4,
          "reviews": "670",
          "description": "Refreshing melon cubes",
          "image": "assets/images/product_5.png",
        },
      ]
    },
    {
      "name": "Organic",
      "icon": "🌱",
      "gradient": [Color(0xFF66BB6A), Color(0xFF81C784)],
      "items": [
        {
          "name": "Organic Apples",
          "icon": "🍏",
          "price": "₹220",
          "unit": "1 kg",
          "rating": 4.8,
          "reviews": "950",
          "description": "Certified organic apples without pesticides",
          "badge": "Organic",
          "image": "assets/images/product_6.png",
        },
        {
          "name": "Organic Bananas",
          "icon": "🍌",
          "price": "₹70",
          "unit": "1 dozen",
          "rating": 4.6,
          "reviews": "780",
          "description": "Naturally ripened organic bananas",
          "image": "assets/images/product_3.png",
        },
        {
          "name": "Organic Papaya",
          "icon": "🥭",
          "price": "₹85",
          "unit": "1 kg",
          "rating": 4.7,
          "reviews": "620",
          "description": "Chemical-free organic papaya",
          "image": "assets/images/product_4.png",
        },
      ]
    },
  ];

  void _onCategoryTap(int index) {
    if (selectedIndex != index) {
      setState(() => selectedIndex = index);
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categories[selectedIndex];
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showBackButton
          ? DefaultCommonAppBar(
        activityName: "Categories",
        backgroundColor: AppColors.primary,
      )
          : AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Categories',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Row(
        children: [
          // LEFT SIDE VERTICAL CATEGORY MENU
          Container(
            width: isMobile ? 90 : (isTablet ? 100 : 110),
            decoration: BoxDecoration(
              color: Colors.grey[50],
            ),
            child: ListView.builder(
              itemCount: categories.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onCategoryTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(
                      vertical: isMobile ? 4 : 6,
                      horizontal: isMobile ? 6 : 8,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 14 : 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          categories[index]["gradient"][0].withOpacity(0.1),
                          categories[index]["gradient"][1].withOpacity(0.15),
                        ],
                      )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          tween: Tween(begin: 0.0, end: isSelected ? -8.0 : 0.0),
                          builder: (context, offset, child) {
                            return Transform.translate(
                              offset: Offset(0, offset),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween(begin: 1.0, end: isSelected ? 1.15 : 1.0),
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Text(
                                      categories[index]["icon"],
                                      style: TextStyle(
                                        fontSize: isMobile ? 28 : (isTablet ? 30 : 32),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: isMobile ? 6 : 8),
                        Text(
                          categories[index]["name"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 9.5 : (isTablet ? 10 : 10.5),
                            height: 1.2,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primary : Colors.black87,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // RIGHT SIDE PRODUCT GRID
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        selectedCategory["gradient"][0].withOpacity(0.03),
                        selectedCategory["gradient"][1].withOpacity(0.03),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 14 : 16)),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isMobile ? 6 : 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: selectedCategory["gradient"],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                selectedCategory["icon"],
                                style: TextStyle(fontSize: isMobile ? 20 : 24),
                              ),
                            ),
                            SizedBox(width: isMobile ? 10 : 12),
                            Expanded(
                              child: Text(
                                selectedCategory["name"],
                                style: AppTextStyles.heading1(context).copyWith(
                                  fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 14 : 18),
                        GridView.builder(
                          itemCount: selectedCategory["items"].length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: isMobile ? 0.68 : (isTablet ? 0.70 : 0.72),
                            crossAxisSpacing: isMobile ? 8 : (isTablet ? 10 : 12),
                            mainAxisSpacing: isMobile ? 10 : (isTablet ? 12 : 14),
                          ),
                          itemBuilder: (context, index) {
                            final item = selectedCategory["items"][index];
                            return _buildProductCard(item, index, isMobile, isTablet);
                          },
                        )
                      ],
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

  Widget _buildProductCard(Map<String, dynamic> item, int index, bool isMobile, bool isTablet) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () => _showProductDetail(item),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: isMobile ? 100 : (isTablet ? 110 : 120),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          padding: EdgeInsets.all(isMobile ? 10 : 12),
                          child: item['image'] != null
                              ? Image.asset(
                            item['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  item["icon"],
                                  style: TextStyle(
                                    fontSize: isMobile ? 40 : 45,
                                  ),
                                ),
                              );
                            },
                          )
                              : Center(
                            child: Text(
                              item["icon"],
                              style: TextStyle(
                                fontSize: isMobile ? 40 : 45,
                              ),
                            ),
                          ),
                        ),
                        if (item['badge'] != null)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 5 : 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: item['badge'].contains('GI')
                                    ? Colors.pink[700]
                                    : (item['badge'].contains('Premium')
                                    ? Colors.amber[700]
                                    : (item['badge'].contains('Organic')
                                    ? Colors.green[700]
                                    : Colors.orange[700])),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['badge'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 7 : 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 4 : 5),
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
                              Icons.favorite_border,
                              size: isMobile ? 12 : 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 6 : 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isMobile ? 10 : 11,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: isMobile ? 2 : 3),
                            if (item['rating'] != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: isMobile ? 10 : 11,
                                    color: Colors.amber[700],
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    '${item['rating']}',
                                    style: TextStyle(
                                      fontSize: isMobile ? 8 : 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      '(${item['reviews']})',
                                      style: TextStyle(
                                        fontSize: isMobile ? 7 : 8,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: isMobile ? 4 : 6),
                            Text(
                              item["price"],
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            if (item['unit'] != null)
                              Text(
                                item['unit'],
                                style: TextStyle(
                                  fontSize: isMobile ? 7 : 8,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            SizedBox(height: isMobile ? 4 : 5),
                            GestureDetector(
                              onTap: () => _showVariantBottomSheet(context, item),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: isMobile ? 5 : 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Add',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 9 : 10,
                                    fontWeight: FontWeight.w600,
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
            ),
          ),
        );
      },
    );
  }

  void _showVariantBottomSheet(BuildContext context, Map<String, dynamic> product) {
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

  void _showProductDetail(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductDetailSheet(product),
    );
  }

  Widget _buildProductDetailSheet(Map<String, dynamic> product) {
    final variants = product['variants'] as List<Map<String, dynamic>>?;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              children: [
                Container(
                  height: isMobile ? 220 : 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: product['image'] != null
                      ? Image.asset(
                    product['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          product["icon"],
                          style: TextStyle(fontSize: isMobile ? 100 : 120),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      product["icon"],
                      style: TextStyle(fontSize: isMobile ? 100 : 120),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  product['name'],
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 8),
                if (product['rating'] != null)
                  Row(
                    children: [
                      Icon(Icons.star, size: isMobile ? 16 : 18, color: Colors.amber[700]),
                      SizedBox(width: isMobile ? 4 : 6),
                      Text(
                        '${product['rating']} (${product['reviews']} reviews)',
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  product['description'] ?? 'Fresh and high quality product',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),
                if (variants != null && variants.isNotEmpty) ...[
                  Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMobile ? 10 : 12),
                  ...variants.map((variant) => Container(
                    margin: EdgeInsets.only(bottom: isMobile ? 10 : 12),
                    padding: EdgeInsets.all(isMobile ? 14 : 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              variant['size'],
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              variant['pricePerUnit'],
                              style: TextStyle(
                                fontSize: isMobile ? 11 : 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          variant['price'],
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )),
                ] else ...[
                  Text(
                    product['price'],
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (product['unit'] != null)
                    Text(
                      product['unit'],
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
                SizedBox(height: isMobile ? 20 : 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product['name']} added to cart'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green[700],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 14 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}