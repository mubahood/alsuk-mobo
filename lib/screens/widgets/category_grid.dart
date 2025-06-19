import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/screens/widgets/shimmer_loading.dart';

import '../../../models/ProductCategory.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/AppConfig.dart';
import '../shop/ProductsScreen.dart';

class CategoryGrid extends StatelessWidget {
  final List<ProductCategory> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final displayedCategories =
    categories.length > 8 ? categories.sublist(0, 8) : categories;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      sliver: SliverGrid(
        //====== THE CHANGE IS HERE ======
        // Switched to SliverGridDelegateWithFixedCrossAxisCount
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // This ensures exactly 4 items per row.
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.9, // Adjusted aspect ratio for a slightly taller look
        ),
        //================================
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            if (categories.isEmpty) {
              return const ShimmerLoadingWidget(height: 150, width: 150);
            }
            final item = displayedCategories.isNotEmpty
                ? displayedCategories.elementAtOrNull(index)
                : null;
            if (item == null) {
              return const SizedBox.shrink(); // Handle potential null case
            }
            return CategoryCard(item: item);
          },
          childCount: categories.isEmpty ? 8 : displayedCategories.length,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.item,
  });

  final ProductCategory item;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () => Get.to(() => ProductsScreen({'category': item})),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: "${AppConfig.MAIN_SITE_URL}/storage/${item.image}",
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const ShimmerLoadingWidget(height: 150, width: 150),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined,
                      color: Colors.grey),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      primaryColor.withOpacity(0.9),
                      primaryColor.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: FxText.bodySmall(
                  item.category,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  height: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: 600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}