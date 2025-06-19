import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/screens/widgets/shimmer_loading.dart';
import 'package:nudipu/utils/Utils.dart';

import '../../../models/VendorModel.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/AppConfig.dart';
import 'VendorScreen.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  late Future<List<VendorModel>> _vendorsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future once. FutureBuilder will handle the rest.
    _vendorsFuture = VendorModel.get_items();
  }

  // This method is called by the RefreshIndicator to fetch new data.
  Future<void> _handleRefresh() async {
    setState(() {
      // Assigning a new future will cause FutureBuilder to re-evaluate.
      _vendorsFuture = VendorModel.get_items();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft, color: AppTheme.theme.colorScheme.onBackground),
          onPressed: () => Get.back(),
        ),
        title: FxText.titleLarge('Vendors', fontWeight: 700),
      ),
      body: FutureBuilder<List<VendorModel>>(
        future: _vendorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer();
          }

          if (snapshot.hasError) {
            return _buildEmptyState(
              icon: FeatherIcons.alertCircle,
              title: 'An Error Occurred',
              subtitle: 'Could not load vendor information.',
            );
          }

          final vendors = snapshot.data;

          if (vendors == null || vendors.isEmpty) {
            return _buildEmptyState(
              icon: FeatherIcons.users,
              title: 'No Vendors Found',
              subtitle: 'Check back later for a list of our trusted vendors.',
            );
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: CustomTheme.primary,
            child: _buildVendorsGrid(vendors),
          );
        },
      ),
    );
  }

  /// The main grid view for displaying vendor cards.
  Widget _buildVendorsGrid(List<VendorModel> vendors) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // A 2-column grid layout
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8, // Adjust for card proportions
      ),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return _VendorCard(vendor: vendors[index]);
      },
    );
  }

  /// A shimmer loading placeholder that mimics the grid layout.
  Widget _buildLoadingShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 6, // Show 6 placeholder cards
      itemBuilder: (context, index) {
        return const ShimmerLoadingWidget(height: 200);
      },
    );
  }

  /// A reusable widget for showing initial or empty states.
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          FxText.titleLarge(title, fontWeight: 700),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FxText.bodyMedium(
              subtitle,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FxButton(
            onPressed: _handleRefresh,
            elevation: 0,
            backgroundColor: CustomTheme.primary,
            child: FxText.bodyMedium(
              'Try Again',
              fontWeight: 600,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

/// A dedicated, newly designed card for a single vendor.
class _VendorCard extends StatelessWidget {
  final VendorModel vendor;
  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the single vendor's product screen
        Get.to(() => VendorScreen({'vendor': vendor}));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.theme.dividerColor, width: 1.5),
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
                  imageUrl: "${Utils.img(vendor.avatar)}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  ShimmerLoadingWidget( height: 150, width: double.infinity), 
                  errorWidget: (context, url, error) => Image.asset(
                      AppConfig.NO_IMAGE,
                      fit: BoxFit.cover),
                ),
              ),
            ),
            // Vendor Name and Button
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FxText.bodyMedium(
                      vendor.name,
                      fontWeight: 700,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FxButton.small(
                      onPressed: () {
                        Get.to(() => VendorScreen({'vendor': vendor}));
                      },
                      elevation: 0,
                      backgroundColor: CustomTheme.primary.withOpacity(0.15),
                      child: FxText.bodySmall(
                        "Shop Now",
                        color: CustomTheme.primary,
                        fontWeight: 600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}