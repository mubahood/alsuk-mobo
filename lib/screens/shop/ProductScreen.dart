import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/ImageModelLocal.dart';
import 'package:nudipu/models/Product.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/MainController.dart';
import '../../models/CartItem.dart';
import '../../sections/widgets.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../cart/CartScreen.dart';

class ProductScreen extends StatefulWidget {
  Product item;

  ProductScreen(this.item, {Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState(item);
}

final MainController mainController = Get.find<MainController>();

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  Product item;

  _ProductScreenState(this.item);

  @override
  void initState() {
    super.initState();
    item.getAttributes();
    init();
  }

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

  List relatedProducts = [];

  Future<dynamic> init() async {
    item.getOnlinePhotos();
    setState(() {});
    downloadedPics = await Utils.getDownloadPics();
    Directory dir = await getApplicationDocumentsDirectory();
    tempPath = dir.path;
    downloaPics();
    setState(() {});

    RxList<dynamic> tempPros = mainController.products;
    tempPros.shuffle();
    if (tempPros.length > 9) {
      relatedProducts = tempPros.sublist(0, 8);
    } else {
      relatedProducts = tempPros;
    }

    List<CartItem> tempCartItems = await CartItem.getItems(
      where: "product_id = ${item.id}",
    );
    if (tempCartItems.isNotEmpty) {
      cartItem = tempCartItems[0];
    } else {
      mainController.cartItemsIDs.remove(item.id.toString());
      mainController.cartItems.removeWhere((element) => element.id == item.id);
      mainController.removeFromCart(item.id.toString());
      setState(() {});
    }

    setState(() {});
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
/*      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Product details",
          color :Colors.white,
          maxLines: 2,
        ),
      ),*/
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: init,
          backgroundColor: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.grey.shade300,
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        viewportFraction: 1,
                                        enlargeCenterPage: false,
                                        enlargeFactor: 1,
                                        enableInfiniteScroll: false,
                                        autoPlay: false,
                                        height: Get.height / 2),
                                    items: item.online_photos
                                        .map((item) => Stack(
                                              children: [
                                                FxContainer(
                                                  onTap: () {
                                                    openPhotos(item);
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    imageUrl:
                                                        "${AppConfig.MAIN_SITE_URL}/storage/${item.thumbnail}",
                                                    placeholder: (context,
                                                            url) =>
                                                        ShimmerLoadingWidget(
                                                            height: double
                                                                .infinity),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Image(
                                                      image: AssetImage(
                                                        AppConfig.NO_IMAGE,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 15,
                                                  right: 15,
                                                  child: FxContainer(
                                                    bordered: true,
                                                    borderRadiusAll: 100,
                                                    color: Colors.black
                                                        .withOpacity(.5),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                    child: FxText.bodyLarge(
                                                      '${(item.position - 1)}',
                                                      color: Colors.white,
                                                      fontWeight: 800,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FxText.titleMedium(
                                        item.name,
                                        color: Colors.black,
                                        fontWeight: 800,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      widget.item.p_type != 'No'
                                          ? SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    children: [
                                                      FxContainer(
                                                        color:
                                                            CustomTheme.primary,
                                                        borderRadiusAll: 0,
                                                        paddingAll: 5,
                                                        child:
                                                            FxText.titleMedium(
                                                          "${AppConfig.CURRENCY}${Utils.moneyFormat(item.price_1)} "
                                                              .toUpperCase(),
                                                          color: Colors.white,
                                                          textAlign:
                                                              TextAlign.start,
                                                          fontWeight: 900,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      FxText.titleMedium(
                                                        "${AppConfig.CURRENCY}${Utils.moneyFormat(item.price_2)} "
                                                            .toUpperCase(),
                                                        color: Colors.grey,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationThickness:
                                                              2,
                                                          decorationColor:
                                                              Colors.grey,
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 16,
                                                          color: CustomTheme
                                                              .primary,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                        fontWeight: 900,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            )
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          childCount: 1, // 1000 list items
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            PriceModel x = widget.item.pricesList[index];
                            if (index == 0) {
                              return Column(
                                children: [
                                  FxContainer(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 3),
                                    alignment: Alignment.centerLeft,
                                    child: FxText.titleLarge(
                                      "Pricing".toUpperCase(),
                                      color: Colors.white,
                                      textAlign: TextAlign.start,
                                      fontWeight: 800,
                                    ),
                                    color: CustomTheme.primary,
                                    borderRadiusAll: 0,
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: FxContainer(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            bordered: true,
                                            borderRadiusAll: 0,
                                            child: FxText.titleSmall(
                                                "Quantity Range".toUpperCase()),
                                          ),
                                        ),
                                        Expanded(
                                          child: FxContainer(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            bordered: true,
                                            borderRadiusAll: 0,
                                            child: FxText.titleSmall(
                                                "Price per item".toUpperCase()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: FxContainer(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            bordered: true,
                                            borderRadiusAll: 0,
                                            child: FxText.titleSmall(
                                                "${x.min_qty} Item${x.min_qty == 1 ? "" : "s"} - ${x.max_qty} Items"
                                                    .toUpperCase()),
                                          ),
                                        ),
                                        Expanded(
                                          child: FxContainer(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            bordered: true,
                                            borderRadiusAll: 0,
                                            child: FxText.titleSmall(
                                              "UGX ${Utils.moneyFormat(x.price.toString())}"
                                                  .toUpperCase(),
                                              color: CustomTheme.primary,
                                              fontWeight: 900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: FxContainer(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      bordered: true,
                                      borderRadiusAll: 0,
                                      child: FxText.titleSmall(
                                          "${x.min_qty} Item${x.min_qty == 1 ? "" : "s"} - ${x.max_qty} Items"
                                              .toUpperCase()),
                                    ),
                                  ),
                                  Expanded(
                                    child: FxContainer(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      bordered: true,
                                      borderRadiusAll: 0,
                                      child: FxText.titleSmall(
                                          "UGX ${Utils.moneyFormat(x.price.toString())}"
                                              .toUpperCase(),
                                          color: CustomTheme.primary,
                                          fontWeight: 900),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount:
                              widget.item.pricesList.length, // 1000 list items
                        ),
                      ),
                      /*
    widget.item.getPrices();
    return;
                      *
                      * */
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            Map<String, String> x = item.attributes[index];
                            return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: singleWidget(x['key']!, x['value']!));
                          },
                          childCount: item.attributes.length, // 1000 list items
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                item.getColors().isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: FxText.titleMedium(
                                              "Colors available".toUpperCase(),
                                              color: Colors.black,
                                              fontWeight: 800,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: 60,
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 15,
                                            ),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  item.getColors().length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String color =
                                                    item.getColors()[index];
                                                return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: FxContainer(
                                                    bordered: true,
                                                    borderRadiusAll: 100,
                                                    border: Border.all(
                                                        color: cartItem.color ==
                                                                color
                                                            ? CustomTheme
                                                                .primary
                                                            : Colors.white,
                                                        width: 5),
                                                    paddingAll: 5,
                                                    color: Colors.white,
                                                    child: FxContainer(
                                                      onTap: () {
                                                        if (cartItem.color ==
                                                            color) {
                                                          cartItem.color = "";
                                                          setState(() {});
                                                          return;
                                                        }
                                                        cartItem.color = color;
                                                        if (cartItem.id > 0) {
                                                          cartItem.save();
                                                        }
                                                        setState(() {});
                                                      },
                                                      width: 40,
                                                      height: 40,
                                                      borderRadiusAll: 100,
                                                      color:
                                                          Utils.getColor(color),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                item.getSizes().isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 15,
                                              right: 15,
                                            ),
                                            child: FxText.titleMedium(
                                              "Select size".toUpperCase(),
                                              color: Colors.black,
                                              fontWeight: 800,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 15,
                                            ),
                                            height: 40,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: item.getSizes().length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String size =
                                                    item.getSizes()[index];
                                                return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: FxContainer(
                                                    bordered: true,
                                                    onTap: () {
                                                      if (cartItem.size ==
                                                          size) {
                                                        cartItem.size = "";
                                                        setState(() {});
                                                        return;
                                                      }
                                                      cartItem.size = size;
                                                      if (cartItem.id > 0) {
                                                        cartItem.save();
                                                      }
                                                      setState(() {});
                                                    },
                                                    borderColor:
                                                        CustomTheme.primary,
                                                    alignment: Alignment.center,
                                                    borderRadiusAll: 10,
                                                    color: cartItem.size == size
                                                        ? CustomTheme.primary
                                                        : Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                    child: Center(
                                                      child: FxText.bodyLarge(
                                                        size,
                                                        color: cartItem.size ==
                                                                size
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight: 900,
                                                        height: .8,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: FxText.titleMedium(
                                    "Item Description ${item.colorList.length}"
                                        .toUpperCase(),
                                    color: Colors.black,
                                    fontWeight: 800,
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Html(
                                    data: item.description,
                                    style: {
                                      '*': Style(
                                        color: Colors.grey.shade700,
                                      ),
                                      "strong": Style(
                                          color: CustomTheme.primary,
                                          fontSize: FontSize(18),
                                          fontWeight: FontWeight.normal),
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(
                                  thickness: 15,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: FxText.titleMedium(
                                    "YOU MAY ALSO LIKE".toUpperCase(),
                                    color: Colors.black,
                                    fontWeight: 800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                          childCount: 1, // 1000 list items
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 3),
                                child: productUi2(relatedProducts[index]));
                          },
                          childCount: relatedProducts.length, // 1000 list items
                        ),
                      ),
                    ],
                  )),
                  const Divider(
                    color: CustomTheme.primary,
                    height: 5,
                  ),
                  Obx(
                    () => Column(
                      children: [
                        (mainController.cartItems.isEmpty)
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  await Get.to(() => const CartScreen());
                                  await init();
                                  setState(() {});
                                },
                                child: Container(
                                  color: CustomTheme.primary,
                                  child: Row(
                                    children: [
                                      FxSpacing.width(8),
                                      FxText.titleSmall(
                                        "You have ${mainController.cartItems.length} items in cart.",
                                        color: Colors.white,
                                      ),
                                      const Spacer(),
                                      FxContainer(
                                        margin: const EdgeInsets.only(
                                            right: 5, top: 5, bottom: 5),
                                        color: CustomTheme.bg_primary_light,
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 5,
                                            top: 4,
                                            bottom: 2),
                                        child: Row(
                                          children: [
                                            FxText.bodySmall(
                                              "CHECKOUT",
                                              fontWeight: 900,
                                              color: CustomTheme.primaryDark,
                                            ),
                                            const Icon(
                                              FeatherIcons.chevronRight,
                                              color: CustomTheme.primaryDark,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    color: CustomTheme.primary.withAlpha(20),
                    padding: const EdgeInsets.only(
                        bottom: 10, right: 10, left: 10, top: 10),
                    child: /*mainController.userModel.id.toString() ==
                            widget.item.user.toString()
                        ? Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: FxButton.block(
                                  onPressed: () {
                                    Utils.toast(
                                        "Edit Feature Is Coming soon...");
                                  },
                                  borderRadiusAll: 10,
                                  child: FxText.titleMedium(
                                    'EDIT',
                                    color: Colors.white,
                                    fontWeight: 900,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: FxButton.block(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        middleText:
                                            "Are you sure you want to delete this product?",
                                        titleStyle: const TextStyle(
                                            color: Colors.black),
                                        actions: <Widget>[
                                          FxButton.outlined(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              Utils.toast("Deleting...");
                                              RespondModel resp = RespondModel(
                                                  await Utils.http_post(
                                                      'products-delete', {
                                                'id': item.id,
                                              }));
                                              if (resp.code != 1) {
                                                Utils.toast(
                                                    "Failed " + resp.message);
                                                return;
                                              }
                                              mainController.getProducts();
                                              Utils.toast(
                                                  "Deleted: " + resp.message);
                                              Navigator.pop(context);
                                            },
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            borderColor: CustomTheme.primary,
                                            child: FxText(
                                              'DELETE',
                                              color: CustomTheme.primary,
                                            ),
                                          ),
                                          FxButton.small(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 19, horizontal: 15),
                                            child: FxText(
                                              'CANCEL',
                                              color: Colors.white,
                                            ),
                                          )
                                        ]);

                                    //print("Delete");
                                    //Utils.toast("Chat System Coming soon...");
                                    //Utils.launchPhone('+256701632257609');
                                  },
                                  backgroundColor: Colors.red.shade700,
                                  borderRadiusAll: 10,
                                  child: FxText.titleMedium(
                                    'DELETE',
                                    color: Colors.white,
                                    fontWeight: 900,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : */
                        Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FxButton.block(
                            backgroundColor: mainController.cartItemsIDs
                                    .contains(widget.item.id.toString())
                                ? Colors.green.shade700
                                : CustomTheme.primaryDark,
                            onPressed: () async {


                              if (mainController.cartItemsIDs
                                  .contains(widget.item.id.toString())) {
                                Get.to(() => const CartScreen());
                              } else {
                                await addToCart();
                              }

                              //Utils.launchPhone('+256701632257609');
                            },
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                            ),
                            borderRadiusAll: 10,
                            child: FxText.titleMedium(
                              mainController.cartItemsIDs
                                      .contains(widget.item.id.toString())
                                  ? 'CHECKOUT'
                                  : 'ADD TO CART',
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                        ),
                        mainController.cartItemsIDs
                                .contains(widget.item.id.toString())
                            ? const SizedBox()
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: FxButton.block(
                                    onPressed: () async {
                                      bool r = await addToCart();
                                      if (!r) {
                                        return;
                                      }

                                      Get.to(() => const CartScreen());

                                      //Get.to(() => ChatScreen(ChatHead(),item));
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 22,
                                    ),
                                    borderRadiusAll: 10,
                                    child: FxText.titleMedium(
                                      'BUY NOW',
                                      color: Colors.white,
                                      fontWeight: 900,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxContainer(
                    onTap: () {
                      Get.back();
                    },
                    bordered: true,
                    margin: const EdgeInsets.all(15),
                    borderRadiusAll: 100,
                    color: Colors.black.withOpacity(0.5),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  FxContainer(
                    onTap: () {
                      Utils.toast('Coming soon...');
                    },
                    bordered: true,
                    margin: const EdgeInsets.all(15),
                    borderRadiusAll: 100,
                    color: Colors.black.withOpacity(0.5),
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  CartItem cartItem = CartItem();

  Future<bool> addToCart() async {
    if (item.getColors().isNotEmpty) {
      if (cartItem.color.isEmpty) {
        Utils.toast("Please first select color");
        return false;
      }
    }

    if (item.getSizes().isNotEmpty) {
      if (cartItem.size.isEmpty) {
        Utils.toast("Please select size");
        return false;
      }
    }

    await mainController.addToCart(widget.item,
        color: cartItem.color, size: cartItem.size);
    setState(() {});
    return true;
  }

  List<String> downloadedPics = [];
  String tempPath = "";

  Future<void> openPhotos(ImageModel pic) async {
    String imageName = pic.src.split('/').last;
    String imagePath = "";
    if (!downloadedPics.contains(imageName)) {
      Utils.toast("Just a minute...");
      await Utils.downloadPhoto(pic.src);
      downloadedPics = await Utils.getDownloadPics();

      Utils.toast("DOES NOT Exists...");
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
    showImageViewer(
      context,
      imageProvider,
      backgroundColor: CustomTheme.primary,
      closeButtonColor: Colors.white,
      closeButtonTooltip: 'Close',
      doubleTapZoomable: true,
      useSafeArea: true,
      immersive: false,
      swipeDismissible: false,
    );

    return;
  }
}
