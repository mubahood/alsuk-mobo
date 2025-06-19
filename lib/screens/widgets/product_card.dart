import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../controllers/MainController.dart';
import '../../../models/Product.dart';
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
    final MainController mainController = Get.find<MainController>();

    return AspectRatio(
      // This is crucial for a responsive grid. It forces the card to have
      // a balanced shape (width is 0.7 times the height).
      aspectRatio: 0.75,
      child: Card(
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
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          "${AppConfig.MAIN_SITE_URL}/storage/${product.feature_photo}",
                      placeholder: (context, url) => ShimmerLoadingWidget(
                          height: 150, width: double.infinity),
                      errorWidget: (context, url, error) =>
                          Image.asset(AppConfig.NO_IMAGE, fit: BoxFit.cover),
                    ),
                    // --- Discount Badge ---
                    if (product.percentate_off.isNotEmpty)
                      _buildDiscountBadge(product.percentate_off),

                    // --- Wishlist Icon ---
                    _buildWishlistButton(),
                  ],
                ),
              ),

              // --- Details Section ---
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name
                    FxText.bodyMedium(
                      product.name,
                      fontWeight: 700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Price and Add to Cart Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Strikethrough old price if discount exists
                            if (product.percentate_off.isNotEmpty)
                              FxText.bodySmall(
                                "${AppConfig.CURRENCY} ${Utils.moneyFormat(product.price_2)}",
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            FxText.titleSmall(
                              "${AppConfig.CURRENCY} ${Utils.moneyFormat(product.price_1)}",
                              color: CustomTheme.primary,
                              fontWeight: 800,
                            ),
                          ],
                        ),
                        // Add to Cart Button
                        Obx(
                          () => FxContainer.rounded(
                            onTap: () {
                              if (!mainController.cartItemsIDs
                                  .contains(product.id.toString())) {
                                mainController.addToCart(product);
                                Utils.toast("Product added to cart.");
                              }
                            },
                            width: 36,
                            height: 36,
                            paddingAll: 0,
                            color: mainController.cartItemsIDs
                                    .contains(product.id.toString())
                                ? Colors.green.withAlpha(220)
                                : CustomTheme.primary,
                            child: Icon(
                              mainController.cartItemsIDs
                                      .contains(product.id.toString())
                                  ? FeatherIcons.check
                                  : FeatherIcons.plus,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the discount percentage badge.
  Widget _buildDiscountBadge(String discount) {
    return Positioned(
      top: 8,
      left: 8,
      child: FxContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: CustomTheme.red,
        borderRadiusAll: 6,
        child: FxText(
          "$discount% OFF",
          color: Colors.white,
          fontSize: 10,
          fontWeight: 700,
        ),
      ),
    );
  }

  /// Builds the wishlist/favorite button.
  Widget _buildWishlistButton() {
    return Positioned(
      top: 4,
      right: 4,
      child: FxContainer.rounded(
        onTap: () {
          // TODO: Implement wishlist functionality
          Utils.toast("Added to wishlist (not implemented yet).");
        },
        paddingAll: 6,
        color: Colors.black.withOpacity(0.25),
        child: const Icon(
          FeatherIcons.heart,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
