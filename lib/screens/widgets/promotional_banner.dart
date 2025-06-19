import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/ProductCategory.dart';
import '../../../screens/shop/ProductsScreen.dart';
import '../../../screens/widgets/shimmer_loading.dart'; // Ensure this import is correct
import '../../../theme/app_theme.dart';
import '../../../utils/AppConfig.dart';

// Converted to a StatefulWidget to manage the state of the pagination dots.
class PromotionalBanner extends StatefulWidget {
  final List<ProductCategory> banners;

  const PromotionalBanner({super.key, required this.banners});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Show a more representative loading skeleton if banners are not yet loaded.
    if (widget.banners.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              const ShimmerLoadingWidget(height: 180, width: double.infinity),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5, // Show 5 placeholder dots
                  (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                // Responsive height based on screen size
                height: MediaQuery.of(context).size.height * 0.22,
                autoPlay: true,
                viewportFraction: 0.89,
                // Shows a bit of the next/previous cards
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                enlargeFactor: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: widget.banners.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () =>
                          Get.to(() => ProductsScreen({'category': item})),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${AppConfig.MAIN_SITE_URL}/storage/${item.banner_image}",
                                placeholder: (context, url) =>
                                    const ShimmerLoadingWidget(height: 180),
                                errorWidget: (context, url, error) =>
                                    Image.asset(AppConfig.NO_IMAGE,
                                        fit: BoxFit.cover),
                              ),
                              // Subtle gradient overlay for a more professional look
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Pagination Dots
            _buildDots(),
          ],
        ),
      ),
    );
  }

  // A dedicated widget for building the pagination dots
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.banners.length,
        (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            width: _currentIndex == index ? 40.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _currentIndex == index
                  ? CustomTheme.accent
                  : Colors.grey.shade400,
            ),
          );
        },
      ),
    );
  }
}
