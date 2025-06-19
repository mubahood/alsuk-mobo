import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/controllers/MainController.dart';

import '../../../models/Product.dart';
import '../../../models/ProductCategory.dart';
import '../../../theme/app_theme.dart';
import '../../models/VendorModel.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class VendorScreen extends StatefulWidget {
  Map<String, dynamic> params;

  VendorScreen(this.params, {Key? key}) : super(key: key);

  @override
  VendorScreenState createState() => VendorScreenState();
}

class VendorScreenState extends State<VendorScreen> {
  late ThemeData theme;

  VendorModel item = VendorModel();

  @override
  void initState() {
    super.initState();
    if (widget.params["category"].runtimeType == category.runtimeType) {
      category = widget.params["category"];
    }
    doRefresh();
  }

  ProductCategory category = ProductCategory();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          'Vendor',
          color: Colors.white,
          maxLines: 1,
          fontWeight: 800,
        ),
      ),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: Text("⌛ Loading..."),
                );
              default:
                return mainWidget();
            }
          }),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();

    setState(() {});
  }

  List<Product> products = [];
  Future<dynamic> myInit() async {
    if (widget.params['vendor'].runtimeType == item.runtimeType) {
      item = widget.params['vendor'];
    }

    if (item.id < 1) {
      Utils.toast("Vendor not found.");
      Get.back();
      return "Done";
    }
    products = await Product.getItems(where: "user=${item.id}");
    return "Done";
  }

  final MainController mainController = Get.find<MainController>();

  Widget mainWidget() {
    return Column(
      children: [
        VendorUi(item),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: RefreshIndicator(
                onRefresh: doRefresh,
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: products.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FxText(
                              'No products found for this vendor.',
                              fontWeight: 800,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FxButton.text(
                                onPressed: () {
                                  doRefresh();
                                },
                                child: FxText(
                                  'Reload',
                                  fontWeight: 800,
                                  color: CustomTheme.primaryDark,
                                ))
                          ],
                        ),
                      )
                    : MasonryGridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          Product pro = products[index];
                          return ProductUi(pro);
                        },
                      )),
          ),
        ),
      ],
    );
  }

}
