import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/screens/widgets/shimmer_loading.dart';
import 'package:nudipu/utils/Utils.dart';

import '../../../models/VendorModel.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/AppConfig.dart';
import '../vendors/VendorScreen.dart'; // Ensure this path is correct for navigation

class VendorList extends StatelessWidget {
  final List<dynamic> vendors;

  const VendorList({super.key, required this.vendors});

  @override
  Widget build(BuildContext context) {
    // This is the correct way to place a horizontally scrolling list
    // inside a CustomScrollView.
    return SliverToBoxAdapter(
      child: Container(
        height: 160, // A defined height for the horizontal list
        margin: const EdgeInsets.only(top: 0),
        child: vendors.isEmpty
            ? _buildLoadingState() // Show shimmer placeholders while loading
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vendors.length,
                // Add padding to the list itself for proper spacing
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  // Use a dedicated, well-designed card for each item
                  return _VendorCard(vendor: vendor);
                },
              ),
      ),
    );
  }

  /// Builds a horizontal list of shimmer placeholders for the loading state.
  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5, // Display 5 placeholders
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(right: 12),
          child: ShimmerLoadingWidget(
            height: 160,
            width: 120,
          ),
        );
      },
    );
  }
}

/// A dedicated, newly designed card for a single vendor in the horizontal list.
class _VendorCard extends StatelessWidget {
  final VendorModel vendor;

  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // A fixed width for each card
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          // Navigate to the single vendor's product screen
          Get.to(() => VendorScreen({'vendor': vendor}));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vendor Logo
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "${Utils.img(vendor.business_logo)}",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerLoadingWidget(
                        height: 150, width: double.infinity),
                    errorWidget: (context, url, error) =>
                        Image.asset(AppConfig.NO_IMAGE, fit: BoxFit.cover),
                  ),
                ),
              ),
              // Vendor Name
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FxText.bodySmall(
                    vendor.name,
                    fontWeight: 700,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
