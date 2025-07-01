import 'dart:async'; // Required for the Timer (debouncing)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../models/Product.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../widgets/shimmer_loading.dart';
import 'ProductScreen.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Product> _products = [];
  bool _isLoading = false;
  String _keyword = "";

  @override
  void initState() {
    super.initState();
    // Add a listener to the controller to handle search logic
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// This method is called whenever the text in the search field changes.
  /// It uses a Timer to "debounce" the input, so the search query only
  /// runs after the user has stopped typing for 500 milliseconds.
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final keyword = _searchController.text.trim();
      if (keyword.length > 1) {
        _performSearch(keyword);
      } else {
        // Clear results if search term is too short
        setState(() {
          _keyword = "";
          _products.clear();
        });
      }
    });
  }

  /// Performs the actual search query against the local database.
  Future<void> _performSearch(String keyword) async {
    setState(() {
      _isLoading = true;
      _keyword = keyword;
    });

    final results = await Product.getItems(where: 'name LIKE \'%$keyword%\'');

    // Ensure the widget is still mounted before updating the state
    if (mounted) {
      setState(() {
        _products = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FeatherIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: _buildSearchField(),
      ),
      body: _buildBody(),
    );
  }

  /// A modern, capsule-style search field.
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon:
              const Icon(FeatherIcons.search, color: Colors.white, size: 20),
          hintText: "Search for products...",
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon:
                      const Icon(FeatherIcons.x, color: Colors.white, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _products.clear();
                      _keyword = "";
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  /// Builds the body of the screen based on the current state.
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_keyword.isEmpty) {
      return _buildEmptyState("Search Products",
          "Find electronics, gadgets, and more.", FeatherIcons.search);
    }

    if (_products.isEmpty) {
      return _buildEmptyState(
          "No Results Found",
          "We couldn't find any products matching '$_keyword'.",
          FeatherIcons.alertCircle);
    }

    // Display the list of product results
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return _ProductResultCard(product: _products[index]);
      },
    );
  }

  /// A reusable widget for showing initial or empty search states.
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          FxText.titleLarge(title, fontWeight: 700),
          const SizedBox(height: 8),
          FxText.bodyMedium(subtitle,
              color: Colors.grey.shade600, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// A dedicated widget for displaying a single product in the search results list.
class _ProductResultCard extends StatelessWidget {
  final Product product;

  const _ProductResultCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => Get.to(() => ProductScreen(product)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.theme.dividerColor),
          ),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "${AppConfig.MAIN_SITE_URL}/storage/${product.feature_photo}",
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  placeholder: (context, url) => const ShimmerLoadingWidget(
                    height: 100,
                    width: 100,
                  ),
                  errorWidget: (context, url, error) =>
                      Image.asset(AppConfig.NO_IMAGE, fit: BoxFit.cover),
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxText.bodyLarge(
                        product.name,
                        fontWeight: 700,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      FxText.titleMedium(
                        "${AppConfig.CURRENCY} ${Utils.moneyFormat(product.price_1)}",
                        fontWeight: 800,
                        color: CustomTheme.primary,
                      ),
                    ],
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
