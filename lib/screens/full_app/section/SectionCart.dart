import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/Product.dart';
import 'package:nudipu/screens/shop/ProductCreateScreen.dart';
import 'package:nudipu/screens/shop/ProductScreen.dart';
import 'package:nudipu/sections/widgets.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:nudipu/utils/AppConfig.dart';

import '../../../controllers/MainController.dart';
import '../../../models/LoggedInUserModel.dart';
import '../../../models/RespondModel.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';
import '../../../utils/my_widgets.dart';
import '../../vendors/BecomeVendorScreen.dart';

class SectionCart extends StatefulWidget {
  MainController mainController;

  SectionCart(this.mainController, {Key? key}) : super(key: key);

  @override
  _SectionCartState createState() => _SectionCartState();
}

class _SectionCartState extends State<SectionCart> {
  late Future<dynamic> futureInit;

  Future<dynamic> do_refresh() async {
    futureInit = my_init();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureInit = my_init();

    mainController = widget.mainController;
  }
  MainController mainController = MainController();
  Future<dynamic> my_init() async {
    return "Done";
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      minLeadingWidth: 10,
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => ProductCreateScreen(const {}));
                      },
                      leading: const Icon(
                        FeatherIcons.plus,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Post new product",
                        fontSize: 18,
                        fontWeight: 800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.bg_primary_light,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const FxContainer(
              width: 10,
              height: 20,
              color: Colors.white,
              borderRadiusAll: 2,
            ),
            FxSpacing.width(8),
            FxText.titleLarge(
              "My Shop",
              fontWeight: 900,
              color: Colors.white,
            ),
          ],
        ),
      ),
      floatingActionButton: mainController.userModel.isVendor()
          ? FloatingActionButton(
              backgroundColor: CustomTheme.primary,
              onPressed: () {
                _showBottomSheet(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(FeatherIcons.plus),
            )
          : null,
      body: SafeArea(
        child: is_loading
            ? myListLoaderWidget(context)
            : (mainController.userModel.id < 1)
                ? notLoggedInWidget()
                : (mainController.userModel.status == 'Pending')
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        alignment: Alignment.center,
                        color: CustomTheme.primary_bg,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                width: Get.width / 3,
                                image: const AssetImage(
                                  'assets/images/shop.png',
                                )),
                            FxSpacing.height(20),
                            FxText.titleLarge(
                              "Account Pending for Approval.",
                              fontWeight: 900,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FxText.bodySmall(
                              "Your account is pending for approval. You will be notified when your account is approved.",
                              fontWeight: 900,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            FxText.bodySmall(
                              "Contact us if you have any questions. ${AppConfig.contact}.",
                              color: Colors.black,
                              fontWeight: 700,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            FxButton.outlined(
                              onPressed: () async {
                                refresh_status();
                              },
                              borderColor: CustomTheme.primary,
                              borderRadiusAll: 100,
                              child: FxText.titleSmall(
                                'REFRESH STATUS'.toUpperCase(),
                                color: CustomTheme.primary,
                                fontWeight: 900,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FxButton.text(
                              onPressed: () async {
                                await Get.to(() => const BecomeVendorScreen());
                                await mainController.getLoggedInUser();
                                refresh_status();
                                setState(() {});
                              },
                              borderColor: CustomTheme.primary,
                              borderRadiusAll: 100,
                              child: FxText.titleSmall(
                                'UPDATE REGISTRATION FORM'.toUpperCase(),
                                color: CustomTheme.primary,
                                fontWeight: 900,
                              ),
                            ),
                          ],
                        ),
                      )
                    : (!mainController.userModel.isVendor())
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            alignment: Alignment.center,
                            color: CustomTheme.primary_bg,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                    width: Get.width / 3,
                                    image: const AssetImage(
                                      'assets/images/shop.png',
                                    )),
                                FxSpacing.height(20),
                                FxText.titleLarge(
                                  "You are not a vendor.",
                                  fontWeight: 900,
                                  color: Colors.black,
                                ),
                                FxText.bodySmall(
                                  "You can't post products",
                                  fontWeight: 900,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                FxText.bodySmall(
                                  "You need to be a registered and verified vendor to post products.",
                                  color: Colors.black,
                                  fontWeight: 700,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                FxButton.block(
                                  onPressed: () async {
                                    await Get.to(
                                        () => const BecomeVendorScreen());
                                    await mainController.getLoggedInUser();
                                    refresh_status();
                                    setState(() {});
                                  },
                                  borderRadiusAll: 100,
                                  child: FxText.titleLarge(
                                    'Become a vendor'.toUpperCase(),
                                    color: Colors.white,
                                    fontWeight: 900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                FxButton.text(
                                  onPressed: () async {
                                    refresh_status();
                                  },
                                  borderColor: CustomTheme.primary,
                                  borderRadiusAll: 100,
                                  child: FxText.titleSmall(
                                    'REFRESH STATUS'.toUpperCase(),
                                    color: CustomTheme.primary,
                                    fontWeight: 900,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : FutureBuilder(
                            future: futureInit,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return myListLoaderWidget(context);
                                default:
                                  return Obx(() => mainWidget());
                              }
                            }),
      ),
    );
  }

  Future<dynamic> doRefresh() async {
    await widget.mainController.getMyProducts();
    setState(() {});
    return "Done";
  }

  Future<dynamic> myInit() async {
    //  await mainController.init();
    await widget.mainController.getCartItems();
    return "Done";
  }

  Widget mainWidget() {
    return widget.mainController.myProducts.isEmpty
        ? Column(
            children: [
              const Spacer(),
              Center(
                child: FxText.titleLarge("You have no products yet."),
              ),
              FxButton(
                borderRadiusAll: 100,
                child: FxText.titleSmall(
                  "Refresh",
                  color: Colors.white,
                  fontWeight: 800,
                ),
                onPressed: () async {
                  await doRefresh();
                },
              ),
              const Spacer()
            ],
          )
        : RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: doRefresh,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Product m = widget.mainController.myProducts[index];
                      return Column(
                        children: [
                          InkWell(
                              onTap: () async {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 210,
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                FeatherIcons.eye,
                                                color: CustomTheme.primary,
                                              ),
                                              title: FxText.bodyLarge(
                                                "View Product",
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Get.to(() => ProductScreen(m));
                                              },
                                              trailing: const Icon(
                                                FeatherIcons.chevronRight,
                                                color: CustomTheme.primary,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                FeatherIcons.edit2,
                                                color: CustomTheme.primary,
                                              ),
                                              title: FxText.bodyLarge(
                                                "Edit Product",
                                              ),
                                              onTap: () {
                                                Utils.toast(
                                                    "Open the web-portal to edit the product.");
                                                return;
                                                Get.back();
                                                Get.to(() =>
                                                    ProductCreateScreen(
                                                        {"item": m}));
                                              },
                                              trailing: const Icon(
                                                FeatherIcons.chevronRight,
                                                color: CustomTheme.primary,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                FeatherIcons.trash2,
                                                color: CustomTheme.primary,
                                              ),
                                              title: FxText.bodyLarge(
                                                "Delete Product",
                                              ),
                                              onTap: () {
                                                Get.back();
                                                Get.defaultDialog(
                                                    middleText:
                                                        "Are you sure you want to delete this product?",
                                                    titleStyle: const TextStyle(
                                                        color: Colors.black),
                                                    actions: <Widget>[
                                                      FxButton.outlined(
                                                        onPressed: () async {
                                                          Get.back();
                                                          Utils.toast(
                                                              "Deleting...");
                                                          RespondModel resp =
                                                              RespondModel(
                                                                  await Utils
                                                                      .http_post(
                                                                          'products-delete',
                                                                          {
                                                                'id': m.id,
                                                              }));
                                                          if (resp.code != 1) {
                                                            Utils.toast(
                                                                "Failed ${resp.message}");
                                                            return;
                                                          }
                                                          await Product
                                                              .deleteProduct(
                                                                  m.id);
                                                          await doRefresh();
                                                          mainController
                                                              .getProducts();
                                                          Utils.toast(
                                                              "Deleted: ${resp.message}");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10,
                                                                horizontal: 15),
                                                        borderColor:
                                                            CustomTheme.primary,
                                                        child: FxText(
                                                          'DELETE',
                                                          color: CustomTheme
                                                              .primary,
                                                        ),
                                                      ),
                                                      FxButton.small(
                                                        onPressed: () {
                                                          Utils.toast(
                                                              "Cancelled");
                                                          Get.back();
                                                        },
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 6,
                                                                horizontal: 15),
                                                        child: FxText(
                                                          'CANCEL',
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ]);
                                              },
                                              trailing: const Icon(
                                                FeatherIcons.chevronRight,
                                                color: CustomTheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });

                                return;
                                await Get.to(() => ProductScreen(m));
                                await doRefresh();
                              },
                              child: productWidget2(m)),
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Divider(
                              height: 0,
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: widget
                        .mainController.myProducts.length, // 1000 list items
                  ),
                ),
              ],
            ),
          );
  }

  bool is_loading = false;

  void refresh_status() async {
    Utils.toast("Refreshing Status...");
    setState(() {
      is_loading = true;
    });
    await LoggedInUserModel.getOnlineItems();
    await LoggedInUserModel.getOnlineItems();
    await Future.delayed(const Duration(seconds: 1));
    await LoggedInUserModel.getOnlineItems();
    await Future.delayed(const Duration(seconds: 1));
    await mainController.getLoggedInUser();
    await mainController.getLoggedInUser();

    setState(() {
      is_loading = false;
    });
    if (mainController.userModel.user_type == 'Vendor' &&
        mainController.userModel.status == 'Active') {
      Utils.toast("You are now approved as a vendor.");
      setState(() {
        is_loading = false;
      });
      //Navigator.pop(context);
      return;
    }
    setState(() {
      is_loading = false;
    });
  }
}
