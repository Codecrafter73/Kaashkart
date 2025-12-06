import 'package:flutter/material.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/category/presentation/widgets/home_category_section_widget.dart';
import 'package:kaashtkart/features/customer/screen/product/home_best_selling_product_list_section_widget.dart';
import 'package:kaashtkart/features/customer/screen/product/home_product_list_section_widget.dart';
import 'components/home_ending_section_widget.dart';
import 'components/home_fixed_header.dart';
import 'components/home_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FixedHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    HomeBannerSliderSection(),
                    ResponsiveHelper.sizedBoxHeight(context, 20),
                    HomeCategorySection( sectionHeading: 'Top Selling Categories',  ),
                    HomelProductListSection( sectionHeading: 'Products',  ),
                    HomeBestSellinglProductListSection( sectionHeading: 'Best Selling',  ),
                    HomeEndingSectionGradient(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}