import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/ImageModelLocal.dart';
import 'package:nudipu/models/Product.dart';
import 'package:nudipu/screens/widgets/product_card.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/MainController.dart';
import '../../models/CartItem.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../chat/chat_screen.dart';
import '../widgets/shimmer_loading.dart';

class ProductScreen extends StatefulWidget {
  final Product item;

  const ProductScreen(this.item, {Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState(item);
}

class _ProductScreenState extends State<ProductScreen> {
  final Product item;

  _ProductScreenState(this.item);

  // --- All your original logic and state variables remain unchanged ---
  final MainController mainController = Get.find<MainController>();
  late Future<dynamic> initFuture;
  CartItem cartItem = CartItem();
  List relatedProducts = [];
  List<String> downloadedPics = [];
  String tempPath = "";

  @override
  void initState() {
    super.initState();
    item.getAttributes();
    initFuture = init();
  }

  Future<dynamic> init() async {
    item.getOnlinePhotos();
    if (mounted) setState(() {});

    // Original logic for handling downloaded pictures
    downloadedPics = await Utils.getDownloadPics();
    Directory dir = await getApplicationDocumentsDirectory();
    tempPath = dir.path;
    downloaPics(); // Runs in background
    if (mounted) setState(() {});

    RxList<dynamic> tempPros = mainController.products;
    tempPros.shuffle();
    relatedProducts = tempPros.length > 9 ? tempPros.sublist(0, 8) : tempPros;

    List<CartItem> tempCartItems =
        await CartItem.getItems(where: "product_id = ${item.id}");
    if (tempCartItems.isNotEmpty) {
      cartItem = tempCartItems[0];
    } else {
      mainController.cartItemsIDs.remove(item.id.toString());
      mainController.cartItems.removeWhere((element) => element.id == item.id);
    }
    if (mounted) setState(() {});
    return "Done";
  }

  // ==============================================================
  // === YOUR ORIGINAL IMAGE HANDLING LOGIC HAS BEEN RESTORED BELOW ===
  // ==============================================================

  Future<dynamic> downloaPics() async {
    downloadedPics = await Utils.getDownloadPics();
    item.getOnlinePhotos();
    for (var pic in item.online_photos) {
      if (!downloadedPics.contains(pic.src)) {
        await Utils.downloadPhoto(pic.src);
        downloadedPics = await Utils.getDownloadPics();
      }
    }
    downloadedPics = await Utils.getDownloadPics();
  }

  Future<void> openPhotos(ImageModel pic) async {
    String imageName = pic.src.split('/').last;
    String imagePath = "";
    if (!downloadedPics.contains(imageName)) {
      Utils.toast("Just a minute...");
      await Utils.downloadPhoto(pic.src);
      downloadedPics = await Utils.getDownloadPics();
      for (var x in downloadedPics) {
        String imageName2 = x.replaceAll('images/', '').split('/').last;
        if (imageName.toLowerCase() == imageName2.toLowerCase()) {
          imageName = x;
          imagePath = "$tempPath/images/$imageName";
          break;
        }
      }
    } else {
      imagePath = "$tempPath/images/$imageName";
    }

    String path_1 = "$tempPath/$imageName";
    String path_2 = "$tempPath/images/$imageName";

    if (await File(path_1).exists()) {
      imagePath = path_1;
    } else {
      if (await File(path_2).exists()) {
        imagePath = path_2;
      }
    }

    if (imagePath.isEmpty) {
      Utils.toast(
          "Failed to find image. ${pic.src.replaceAll('images/', '').split('/').last}");
      return;
    }

    ImageProvider imageProvider = FileImage(File(imagePath));
    await showImageViewer(
      context,
      imageProvider,
      doubleTapZoomable: true,
      useSafeArea: true,
    );
    // To exit full screen, call this method:
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _onShare() {
    final textToShare = "Check out this product on ${AppConfig.APP_NAME}!\n\n"
        "${item.name}\n"
        "Price: ${AppConfig.CURRENCY} ${Utils.moneyFormat(item.price_1)}\n\n"
        "Get the app here: ${AppConfig.APP_LINK}";

    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: init,
              color: CustomTheme.primary,
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        _buildSliverAppBar(),
                        _buildProductHeader(),
                        _buildPricingSection(),
                        _buildVariantSelector(),
                        _buildDescription(),
                        _buildWholesalePricing(),
                        if (relatedProducts.isNotEmpty) _buildRelatedProducts(),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    ),
                  ),
                  _buildBottomActionBar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =================== IMPROVED UI WIDGETS =====================

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: Get.height * 0.45,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Get.back(),
          icon:
              const Icon(FeatherIcons.arrowLeft, color: Colors.white, size: 20),
          padding: EdgeInsets.zero,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _onShare,
            icon:
                const Icon(FeatherIcons.share2, color: Colors.white, size: 20),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade50,
                Colors.white,
              ],
            ),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              height: double.infinity,
              enlargeCenterPage: false,
            ),
            items: item.online_photos
                .map((img) => GestureDetector(
                      onTap: () => openPhotos(img),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "${AppConfig.MAIN_SITE_URL}/storage/${img.thumbnail}",
                            placeholder: (context, url) =>
                                const ShimmerLoadingWidget(
                                    height: 300, width: double.infinity),
                            errorWidget: (context, url, error) => const Image(
                                image: AssetImage(AppConfig.NO_IMAGE),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CustomTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CustomTheme.primary.withOpacity(0.3)),
              ),
              child: FxText.bodySmall(
                item.category_text.toUpperCase(),
                color: CustomTheme.primary,
                fontWeight: 700,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 16),

            // Product Name
            FxText.headlineSmall(
              item.name,
              fontWeight: 800,
              color: AppTheme.theme.colorScheme.onBackground,
              height: 1.3,
            ),

            const SizedBox(height: 8),

            // Supplier Info
            if (item.user.isNotEmpty)
              Row(
                children: [
                  Icon(
                    FeatherIcons.user,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: FxText.bodyMedium(
                      "Sold by ${item.user}",
                      color: Colors.grey.shade600,
                      fontWeight: 500,
                    ),
                  ),
                  // Chat Button
                  Container(
                    decoration: BoxDecoration(
                      color: CustomTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => ChatScreen({
                              'task': 'PRODUCT_CHAT',
                              'receiver_id': item.user.toString(),
                              'product': item,
                              'start_message':
                                  'Hello, I am interested in this product - ${item.name}.\n\n',
                            }));
                      },
                      icon: const Icon(
                        FeatherIcons.messageCircle,
                        color: Colors.white,
                        size: 18,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FxText.headlineMedium(
                  "${AppConfig.CURRENCY} ${Utils.moneyFormat(item.price_1)}",
                  color: CustomTheme.primary,
                  fontWeight: 800,
                ),
                const SizedBox(width: 12),
                if (item.percentate_off.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodyLarge(
                        "${AppConfig.CURRENCY} ${Utils.moneyFormat(item.price_2)}",
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade500,
                        fontWeight: 600,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FxText.bodySmall(
                          "${item.percentate_off}% OFF",
                          color: Colors.red.shade700,
                          fontWeight: 700,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (item.pricesList.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomTheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: CustomTheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.tag,
                      size: 16,
                      color: CustomTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    FxText.bodyMedium(
                      "Wholesale pricing available",
                      color: CustomTheme.primary,
                      fontWeight: 600,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVariantSelector() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colors Section
            if (item.getColors().isNotEmpty) ...[
              FxText.titleMedium(
                "Colors",
                fontWeight: 700,
                color: AppTheme.theme.colorScheme.onBackground,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.getColors().map((color) {
                  final isSelected = cartItem.color == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        cartItem.color = isSelected ? "" : color;
                        if (cartItem.id > 0) cartItem.save();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomTheme.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? CustomTheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: FxText.bodyMedium(
                        color,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? 600 : 500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Sizes Section
            if (item.getSizes().isNotEmpty) ...[
              FxText.titleMedium(
                "Sizes",
                fontWeight: 700,
                color: AppTheme.theme.colorScheme.onBackground,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.getSizes().map((size) {
                  final isSelected = cartItem.size == size;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        cartItem.size = isSelected ? "" : size;
                        if (cartItem.id > 0) cartItem.save();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomTheme.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? CustomTheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: FxText.bodyMedium(
                        size,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? 600 : 500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWholesalePricing() {
    if (item.pricesList.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CustomTheme.primary.withOpacity(0.05),
              CustomTheme.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CustomTheme.primary.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomTheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    FeatherIcons.package,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                FxText.titleMedium(
                  "Wholesale Pricing",
                  fontWeight: 700,
                  color: CustomTheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...item.pricesList.map((priceModel) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodyMedium(
                          "Quantity",
                          color: Colors.grey.shade600,
                          fontWeight: 500,
                        ),
                        FxText.titleMedium(
                          "${priceModel.min_qty} - ${priceModel.max_qty} pcs",
                          fontWeight: 700,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FxText.bodyMedium(
                          "Unit Price",
                          color: Colors.grey.shade600,
                          fontWeight: 500,
                        ),
                        FxText.titleMedium(
                          "${AppConfig.CURRENCY} ${Utils.moneyFormat(priceModel.price)}",
                          color: CustomTheme.primary,
                          fontWeight: 700,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.info,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FxText.bodySmall(
                      "Contact seller for bulk orders and custom pricing",
                      color: Colors.blue.shade700,
                      fontWeight: 500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Address
            if (item.supplier.length > 4) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.mapPin,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FxText.bodyMedium(
                        item.supplier,
                        color: Colors.grey.shade700,
                        fontWeight: 500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Description Section
            FxText.titleMedium(
              "Product Description",
              fontWeight: 700,
              color: AppTheme.theme.colorScheme.onBackground,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Html(
                data: item.description.isNotEmpty
                    ? item.description
                    : "No description available",
                style: {
                  "*": Style(
                    color: Colors.grey.shade700,
                    fontSize: FontSize.medium,
                    lineHeight: LineHeight(1.5),
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 8),
                  ),
                  "h1, h2, h3, h4, h5, h6": Style(
                    color: AppTheme.theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedProducts() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: CustomTheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                FxText.titleMedium(
                  "You Might Also Like",
                  fontWeight: 700,
                  color: AppTheme.theme.colorScheme.onBackground,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                return Container(
                  width: Get.width * 0.45,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ProductCard(product: relatedProducts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(

        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Call Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: CustomTheme.primary, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () {
                  if (item.url.length < 5) {
                    Utils.toast("No phone number provided");
                    return;
                  }
                  Utils.launchPhone(item.url);
                },
                icon: Icon(
                  FeatherIcons.phone,
                  color: CustomTheme.primary,
                  size: 24,
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(width: 16),

            // Chat Button
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomTheme.primary,
                      CustomTheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CustomTheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (item.user.toString().trim() ==
                          mainController.userModel.id.toString().trim()) {
                        Utils.toast("You can't contact yourself");
                        return;
                      }
                      Get.to(() => ChatScreen({
                            'task': 'PRODUCT_CHAT',
                            'receiver_id': item.user.toString(),
                            'product': item,
                            'start_message':
                                'I am interested in this product - ${item.name} @ ${AppConfig.CURRENCY} ${Utils.moneyFormat(item.price_1)}. \n\n',
                          }));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FeatherIcons.messageCircle,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          FxText.bodyLarge(
                            "Chat With Seller",
                            color: Colors.white,
                            fontWeight: 700,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
