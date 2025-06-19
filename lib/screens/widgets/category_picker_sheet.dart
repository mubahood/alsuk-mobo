import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../models/ProductCategory.dart';
import '../../../../theme/app_theme.dart';
import '../shop/ProductsScreen.dart';

class CategoryPickerBottomSheet extends StatelessWidget {
  final List<dynamic> categories;

  const CategoryPickerBottomSheet({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Make the height dynamic, but not more than 80% of the screen
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.theme.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle and Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.titleMedium(
                  'Filter by Category',
                  fontWeight: 700,
                  color: AppTheme.theme.colorScheme.onBackground,
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.theme.cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FeatherIcons.x,
                      size: 20,
                      color: AppTheme.theme.colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Category List
          Expanded(
            child: ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: FxText.bodyLarge(category.category),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    size: 20,
                  ),
                  onTap: () {
                    // Close the bottom sheet
                    Navigator.pop(context);
                    // Navigate to the products screen with the selected category
                    Get.to(() => ProductsScreen({'category': category}));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}