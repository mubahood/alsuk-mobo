import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart'; // <-- IMPORT aDDED
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/ImageModelLocal.dart'; // <-- IMPORT ADDED
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
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: init,
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        _buildAppBarAndImageSlider(),
                        _buildProductHeader(),
                        _buildDescription(),
                        if (relatedProducts.isNotEmpty) _buildRelatedProducts(),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

  // =================== UI WIDGETS =====================

  Widget _buildAppBarAndImageSlider() {
    return SliverAppBar(
      expandedHeight: Get.height * 0.4,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: FxContainer.rounded(
        onTap: () => Get.back(),
        margin: const EdgeInsets.all(8),
        paddingAll: 8,
        color: Colors.black.withOpacity(0.5),
        child:
            const Icon(FeatherIcons.arrowLeft, color: Colors.white, size: 20),
      ),
      actions: [
        FxContainer.rounded(
          onTap: _onShare,
          margin: const EdgeInsets.all(8),
          paddingAll: 8,
          color: Colors.black.withOpacity(0.5),
          child: const Icon(FeatherIcons.share2, color: Colors.white, size: 20),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 56, vertical: 12),
        centerTitle: false,
        title: FxText.bodyMedium(item.name,
            color: AppTheme.theme.colorScheme.onBackground,
            fontWeight: 700,
            overflow: TextOverflow.ellipsis),
        background: CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1, autoPlay: true, height: double.infinity),
          // RESTORED FUNCTIONALITY: The map now returns a GestureDetector to trigger the image viewer
          items: item.online_photos
              .map((img) => GestureDetector(
                    onTap: () => openPhotos(img),
                    // This now calls your original function
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageUrl:
                          "${AppConfig.MAIN_SITE_URL}/storage/${img.thumbnail}",
                      placeholder: (context, url) => const ShimmerLoadingWidget(
                          height: 200, width: double.infinity),
                      errorWidget: (context, url, error) => const Image(
                          image: AssetImage(AppConfig.NO_IMAGE),
                          fit: BoxFit.cover),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ALL OTHER UI WIDGETS REMAIN UNCHANGED
  Widget _buildProductHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.bodySmall(item.category_text.toUpperCase(),
                color: CustomTheme.primary, fontWeight: 700),
            const SizedBox(height: 8),
            FxText.titleLarge(item.name, fontWeight: 800),
            const SizedBox(height: 12),
            Row(
              children: [
                FxText.titleMedium(
                    "${AppConfig.CURRENCY} ${Utils.moneyFormat(item.price_1)}",
                    color: AppTheme.theme.colorScheme.onBackground,
                    fontWeight: 800),
                const SizedBox(width: 12),
                if (item.percentate_off.isNotEmpty)
                  FxText.bodyLarge(
                    "${AppConfig.CURRENCY} ${Utils.moneyFormat(item.price_2)}",
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade500,
                    fontWeight: 600,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantSelector() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.getColors().isNotEmpty)
              _buildAttributeSection(
                title: "Color",
                options: item.getColors(),
                selectedValue: cartItem.color,
                onSelected: (value) {
                  setState(() {
                    cartItem.color = (cartItem.color == value) ? "" : value;
                    if (cartItem.id > 0) cartItem.save();
                  });
                },
              ),
            if (item.getSizes().isNotEmpty)
              _buildAttributeSection(
                title: "Size",
                options: item.getSizes(),
                selectedValue: cartItem.size,
                onSelected: (value) {
                  setState(() {
                    cartItem.size = (cartItem.size == value) ? "" : value;
                    if (cartItem.id > 0) cartItem.save();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeSection({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        FxText.titleMedium(title, fontWeight: 700),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              backgroundColor: Colors.grey.shade100,
              selectedColor: CustomTheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: isSelected
                        ? CustomTheme.primary
                        : Colors.grey.shade300),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWholesalePricing() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            FxText.titleMedium("Wholesale Pricing", fontWeight: 700),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: item.pricesList.map((price) {
                  final isLast = item.pricesList.last == price;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.bodyMedium(
                            "Buy ${price.min_qty} - ${price.max_qty} items"),
                        FxText.bodyMedium(
                            "${AppConfig.CURRENCY} ${Utils.moneyFormat(price.price)} / each",
                            fontWeight: 700),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.supplier.length > 4)
              FxText(
                'ADDRESS: ${item.supplier}',
              ),
            const SizedBox(height: 8),
            FxText.titleMedium("Description", fontWeight: 700),
            const SizedBox(height: 8),
            Html(data: item.description, style: {
              "*": Style(color: Colors.grey.shade700, fontSize: FontSize.medium)
            }),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: FxText.titleMedium("You Might Also Like".toUpperCase(),
                color: CustomTheme.primary, fontWeight: 800),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: Get.width * 0.45,
                    child: ProductCard(product: relatedProducts[index]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -5))
      ]),
      child: Row(
        children: [
          FxButton.outlined(
            onPressed: () {
              if (item.url.length < 5) {
                Utils.toast("No phone number provided");
                return;
              }
              Utils.launchPhone(item.url);
            },
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            borderColor: CustomTheme.primary,
            child: const Icon(FeatherIcons.phone,
                color: CustomTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FxButton(
              onPressed: () {
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
                          'I am interested in this product - ${item.name} @ UGX ${Utils.moneyFormat(item.price_1)}. \n\n',
                    }));
              },
              padding: const EdgeInsets.symmetric(vertical: 0),
              backgroundColor: CustomTheme.primaryDark,
              child: FxText.bodyLarge("Chat With Seller",
                  color: Colors.white, fontWeight: 700),
            ),
          ),
        ],
      ),
    );
  }
}
