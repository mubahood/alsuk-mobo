import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/controllers/MainController.dart';
import 'package:nudipu/screens/shop/ProductScreen.dart';
import 'package:nudipu/utils/AppConfig.dart';

import '../../../models/Product.dart';
import '../../../models/ProductCategory.dart';
import '../../../sections/widgets.dart';
import '../../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import 'ProductSearchScreen.dart';

class ProductsScreen extends StatefulWidget {
  final Map<String, dynamic> params;

  const ProductsScreen(this.params, {Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ThemeData theme;
  late Future<dynamic> futureInit;
  List<Product> products = [];
  ProductCategory category = ProductCategory();
  final MainController mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    if (widget.params["category"] != null &&
        widget.params["category"].runtimeType == category.runtimeType) {
      category = widget.params["category"];
    }
    doRefresh();
  }

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
    return futureInit;
  }

  Future<dynamic> myInit() async {
    // Load categories if needed
    await mainController.getCategories();

    // Fetch products based on category filter
    if (category.id > 0) {
      products = await Product.getItems(where: 'category = ${category.id}');
    } else {
      products = await Product.getItems();
    }
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          category.id > 0 ? category.category : "Products",
          color: Colors.white,
          maxLines: 2,
        ),
        actions: [
          IconButton(
            onPressed: showBottomSheetCategoryPicker,
            icon: const Icon(FeatherIcons.alignRight,
                color: Colors.white, size: 30),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const ProductSearchScreen());
            },
            icon:
                const Icon(FeatherIcons.search, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 7),
        ],
      ),
      body: FutureBuilder(
        future: futureInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("⌛ Loading..."));
          } else {
            return mainWidget();
          }
        },
      ),
    );
  }

  Widget mainWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FxText(
                              'No products found in this category.',
                              fontWeight: 800,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            FxButton.text(
                              onPressed: showBottomSheetCategoryPicker,
                              backgroundColor:
                                  CustomTheme.primary.withAlpha(40),
                              child: FxText(
                                'CHANGE FILTER',
                                color: CustomTheme.primary,
                                fontWeight: 700,
                              ),
                            )
                          ],
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.76,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                Product pro = products[index];
                                return FxContainer(
                                  borderColor: CustomTheme.primaryDark,
                                  bordered: false,
                                  color: CustomTheme.primary.withAlpha(40),
                                  borderRadiusAll: 8,
                                  paddingAll: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => ProductScreen(pro));
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  Utils.img(pro.feature_photo),
                                              placeholder: (context, url) =>
                                                  ShimmerLoadingWidget(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                AppConfig.NO_IMAGE,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: FxText.titleSmall(
                                                pro.name,
                                                height: 1.1,
                                                fontWeight: 800,
                                                maxLines: 1,
                                                color: Colors.black,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: FxText.bodyMedium(
                                                    Utils.money(pro.price_1),
                                                    color:
                                                        CustomTheme.primaryDark,
                                                    fontWeight: 800,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                FxCard(
                                                  marginAll: 0,
                                                  color: CustomTheme.primary,
                                                  onTap: () {
                                                    mainController
                                                        .addToCart(pro);
                                                  },
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  child: FxText.bodySmall(
                                                    'BUY NOW',
                                                    fontWeight: 800,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: products.length,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showBottomSheetCategoryPicker() {
    showModalBottomSheet(
      context: context,
      barrierColor: CustomTheme.primary.withOpacity(.5),
      builder: (BuildContext buildContext) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MySize.size16),
              topRight: Radius.circular(MySize.size16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.titleMedium(
                        'Filter by categories',
                        color: Colors.black,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Icon(FeatherIcons.x, color: Colors.red),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: mainController.categories.length,
                    itemBuilder: (context, position) {
                      ProductCategory cat = mainController.categories[position];
                      return ListTile(
                        onTap: () {
                          category = cat;
                          setState(() {});
                          doRefresh();
                          Navigator.pop(context);
                        },
                        title: FxText.titleMedium(
                          cat.category,
                          color: CustomTheme.primary,
                          maxLines: 1,
                          fontWeight: 700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: cat.id != category.id
                            ? const SizedBox()
                            : const Icon(Icons.check_circle,
                                color: CustomTheme.primary, size: 30),
                        visualDensity: VisualDensity.compact,
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
