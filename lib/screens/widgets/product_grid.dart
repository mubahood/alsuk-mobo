import 'package:flutter/material.dart';
import 'package:nudipu/screens/widgets/product_card.dart';

import '../../../../models/Product.dart';
import '../../../../sections/widgets.dart';
import '../../utils/my_widgets.dart';

class ProductGrid extends StatelessWidget {
  final List<dynamic> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjust as needed for your ProductItemUi
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (products.isEmpty) {
              return ShimmerLoadingWidget(height: 200);
            }
            final product = products[index];
            // You should have a well-designed ProductItemUi widget
            // For now, using the one from your old code
            return ProductCard(product: product);
          },
          childCount: products.isEmpty ? 6 : products.length,
        ),
      ),
    );
  }
}
