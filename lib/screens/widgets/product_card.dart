import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/MainController.dart';
import '../../../models/Product.dart';
import '../../../screens/chat/chat_screen.dart';
import '../../../screens/shop/ProductScreen.dart';
import '../../../screens/widgets/shimmer_loading.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // We get the controller here to use for the chat action.
    final MainController mainController = Get.find<MainController>();
    final theme = Theme.of(context);

    return Card(
      // The Card widget provides elevation, a defined shape, and clipping.
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Get.to(() => ProductScreen(product)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image Section with Overlays ---
            _buildImageSection(),

            // --- Details Section ---
            _buildDetailsSection(theme, mainController),
          ],
        ),
      ),
    );
  }

  /// Builds the top part of the card containing the image and overlays.
  Widget _buildImageSection() {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "${AppConfig.MAIN_SITE_URL}/storage/${product.feature_photo}",
            placeholder: (context, url) => const ShimmerLoadingWidget(
                height: 150,
                width: double.infinity, // Use double.infinity for full width
                useGray: true),
            errorWidget: (context, url, error) =>
                Image.asset(AppConfig.NO_IMAGE, fit: BoxFit.cover),
          ),

          // --- Wishlist Icon ---
          _buildWishlistButton(),
        ],
      ),
    );
  }

  /// Builds the bottom part of the card with product details and actions.
  Widget _buildDetailsSection(ThemeData theme, MainController mainController) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Reduced padding for a tighter look
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600, height: 1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 0), // Space between name and discount badge
          // Price and Chat Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price
              Expanded(
                child: Text(
                  "${AppConfig.CURRENCY} ${Utils.moneyFormat(product.price_1)}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: CustomTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the discount percentage badge.
  Widget _buildDiscountBadge(String discount) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: CustomTheme.red, borderRadius: BorderRadius.circular(6)),
        child: Text(
          "$discount% OFF",
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Builds the wishlist/favorite button.
  Widget _buildWishlistButton() {
    return Positioned(
      top: 4,
      right: 4,
      child: InkWell(
        onTap: () {
          Utils.toast("Added to wishlist (not implemented yet).");
        },
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
          ),
          child: const Icon(FeatherIcons.heart, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
