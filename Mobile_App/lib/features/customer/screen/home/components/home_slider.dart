
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';



class HomeBannerSliderSection extends StatefulWidget {
  const HomeBannerSliderSection({super.key});

  @override
  State<HomeBannerSliderSection> createState() => _HomeBannerSliderSectionState();
}

class _HomeBannerSliderSectionState extends State<HomeBannerSliderSection> {
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  final List<String> _bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.webp',
    'assets/images/banner1.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_currentIndex < _bannerImages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResponsiveHelper.sizedBoxHeight(context, 10),
        SizedBox(
          height: ResponsiveHelper.containerHeight(context, 200),
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildCarouselItem(context, _bannerImages[index]);
            },
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 12)),
        // Carousel Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _bannerImages.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: ResponsiveHelper.containerWidth(
                context,
                _currentIndex == entry.key ? 24 : 8,
              ),
              height: ResponsiveHelper.containerHeight(context, 4),
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.spacing(context, 4),
              ),
              decoration: BoxDecoration(
                borderRadius: ResponsiveHelper.borderRadiusAll(context, 4),
                color: _currentIndex == entry.key
                    ? Color(0xFF1B3A2F)
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, String imagePath) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.spacing(context, 16),
      ),
      decoration: BoxDecoration(
        borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image not found
            return Container(
              color: Color(0xFF1B3A2F),
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white.withOpacity(0.5),
                  size: ResponsiveHelper.iconSize(context, 48),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
