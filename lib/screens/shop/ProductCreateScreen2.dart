import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nudipu/models/ImageModelLocal.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/Utils.dart';
import '../../controllers/MainController.dart';
import '../../models/Product.dart';
import '../../models/ProductCategory.dart';
import '../../models/RespondModel.dart';
import '../../utils/SizeConfig.dart';

class ProductCreateScreen2 extends StatefulWidget {
  Product item;

  ProductCreateScreen2(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  CaseCreateBasicState createState() => CaseCreateBasicState();
}

class CaseCreateBasicState extends State<ProductCreateScreen2>
    with SingleTickerProviderStateMixin {
  CaseCreateBasicState();

  bool is_loading = false;

  bool mainLoading = false;
  String error_message = '';

  @override
  void initState() {
    super.initState();

    widget.item.productCategory.getAttributesList();
    futureInit = my_init();
  }

  Future<dynamic> my_init() async {
    if (mainController.userModel.id < 1) {
      Utils.toast("Please login first");
      Navigator.pop(context);
      return;
    }
    return "Done";
  }

  Future<dynamic> my_update() async {
    setState(() {
      futureInit = my_init();
    });
  }

  final _fKey = GlobalKey<FormBuilderState>();
  String specific_action_taken = "";

  Future<bool> onBackPress() async {
    Get.defaultDialog(
        middleText: "Are you sure you want quit adding new product?",
        titleStyle: const TextStyle(color: Colors.black),
        actions: <Widget>[
          FxButton.outlined(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            borderColor: Colors.grey.shade700,
            child: FxText(
              'CANCEL',
              color: Colors.grey.shade700,
              fontWeight: 700,
            ),
          ),
          FxButton.small(
            backgroundColor: Colors.red,
            onPressed: () {
              deleteLocalAnimal();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: FxText(
              'QUIT',
              color: Colors.white,
              fontWeight: 700,
            ),
          )
        ]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        systemOverlayStyle: Utils.overlay(),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: FxText.titleLarge(
          "Uploading product",
          color: Colors.black,
          fontWeight: 700,
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
                return main_content();
            }
          }),
    );
  }

  late Future<dynamic> futureInit;
  final MainController mainController = Get.find<MainController>();

  bool _keyboardVisible = false;

  main_content() {
    return FormBuilder(
      key: _fKey,
      child: Stack(
        children: [
          mainLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText(
                                    'Basic Information',
                                    fontWeight: 800,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FxContainer(
                                    paddingAll: 0,
                                    height: 5,
                                    width: Get.width / 3,
                                    color: Colors.grey.shade600,
                                  )
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText(
                                    'More Details',
                                    fontWeight: 800,
                                    color: CustomTheme.primary,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FxContainer(
                                    paddingAll: 0,
                                    height: 5,
                                    width: Get.width / 3,
                                    color: CustomTheme.primary,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    Expanded(
                      child: FxContainer(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        padding:
                            const EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: widget
                                .item.productCategory.attributesList.isEmpty
                            ? FxContainer(
                                width: Get.width,
                                color: Colors.white,
                                child: FxText.bodyLarge(
                                  "Your product is ready to upload!",
                                  fontWeight: 700,
                                  textAlign: TextAlign.center,
                                  color: Colors.black,
                                ),
                              )
                            : CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        String name = widget
                                            .item
                                            .productCategory
                                            .attributesList[index];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: FormBuilderTextField(
                                            decoration:
                                                CustomTheme.input_decoration(
                                              labelText: name,
                                            ),
                                            onChanged: (value) {
                                              widget.item.productCategory
                                                  .attributesData
                                                  .update(name,
                                                      (v) => value.toString(),
                                                      ifAbsent: () =>
                                                          value.toString());
                                            },
                                            initialValue: widget
                                                        .item
                                                        .productCategory
                                                        .attributesData[name] ==
                                                    null
                                                ? ""
                                                : widget.item.productCategory
                                                    .attributesData[name]
                                                    .toString(),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction: index ==
                                                    (widget
                                                            .item
                                                            .productCategory
                                                            .attributesList
                                                            .length -
                                                        1)
                                                ? TextInputAction.done
                                                : TextInputAction.next,
                                            name: widget.item.productCategory
                                                .attributesList[index],
                                          ),
                                        );
                                      },
                                      childCount: widget
                                          .item
                                          .productCategory
                                          .attributesList
                                          .length, // 1000 list items
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    error_message.isNotEmpty
                        ? FxContainer(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: Get.width,
                            color: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: FxText.bodyMedium(
                              error_message,
                              color: Colors.white,
                              fontWeight: 400,
                            ),
                          )
                        : const SizedBox(),
                    _keyboardVisible
                        ? const SizedBox()
                        : is_loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              )
                            : FxContainer(
                                color: Colors.white,
                                borderRadiusAll: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Column(
                                  children: [
                                    FxButton.block(
                                        onPressed: () {
                                          submit();
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        backgroundColor: CustomTheme.primary,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FxText.titleLarge(
                                              'SUBMIT',
                                              color: Colors.white,
                                              fontWeight: 800,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(FeatherIcons.check)
                                          ],
                                        )),
                                  ],
                                )),
                  ],
                ),
        ],
      ),
    );
  }

  List<String> uploadedPics = [];
  List<String> photosToUpload = [];

  do_pick_image_from_gallary() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    for (var element in images) {
      await saveLocalImage(element.path);
    }

    await getItemImages();
    uploadPics();
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
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
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
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: mainController.categories.length,
                        itemBuilder: (context, position) {
                          ProductCategory cat =
                              mainController.categories[position];
                          return ListTile(
                            onTap: () {
                              category = cat;
                              setState(() {});
                              _fKey.currentState!.patchValue({
                                'category_text': category.category,
                              });

                              Navigator.pop(context);
                            },
                            title: FxText.titleMedium(
                              cat.category,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            trailing: cat.id != category.id
                                ? const SizedBox()
                                : const Icon(
                                    Icons.check_circle,
                                    color: CustomTheme.primary,
                                    size: 30,
                                  ),
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ProductCategory category = ProductCategory();

  single_image_ui(String m, int index) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomTheme.primary,
              width: 5,
            ),
            color: CustomTheme.primary.withAlpha(25),
          ),
          padding: const EdgeInsets.all(0),
          child: Image.file(
            File(m),
            fit: BoxFit.fitWidth,
            width: 100,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 40,
          left: 40,
          child: Center(
              child: FxContainer(
            paddingAll: 5,
            color: uploadedPics.contains(m)
                ? Colors.green.shade700
                : Colors.white.withOpacity(.6),
            borderRadiusAll: 100,
            child: uploadedPics.contains(m)
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                  ),
          )),
        ),
        Positioned(
            right: 0,
            child: InkWell(
              onTap: () => {removeImage(m, index)},
              child: Container(
                child: FxContainer(
                  width: 35,
                  alignment: Alignment.center,
                  borderRadiusAll: 17,
                  height: 35,
                  color: Colors.red.shade700,
                  paddingAll: 0,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Future<void> deleteLocalAnimal() async {}

  uploadPics() async {
    if (is_loading) {
      return;
    }
    is_loading = true;
    for (var x in widget.item.local_photos) {
      if (uploadedPics.contains(x.src)) {
        continue;
      }
      if (await x.uploadSelf()) {
        uploadedPics.add(x.src);
      }
      setState(() {});
      is_loading = false;
      uploadPics();
      break;
    }
  }

  saveLocalImage(String path) async {
    ImageModel img = ImageModel();
    img.type = 'Product';
    img.src = path;
    img.parent_id = widget.item.id.toString();
    img.product_id = widget.item.id.toString();
    photosToUpload.add(img.src);
    await img.save();
    widget.item.local_photos.add(img);
    setState(() {});
  }

  getItemImages() {}

  removeImage(String m, int index) async {
    photosToUpload.removeAt(index);
    setState(() {});
    for (var x in widget.item.local_photos) {
      if (x.src == m) {
        widget.item.local_photos.removeAt(index);
        await x.delete();
        break;
      }
    }

    setState(() {});
  }

  Future<void> submit() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast2("First fix issues before you proceed.");
      return;
    }
    setState(() {
      is_loading = true;
    });
    uploadPics();

    var data = widget.item.toJson();
    data['category_id'] = category.id;
    widget.item.productCategory.getAttributesList();
    if (widget.item.productCategory.attributesData.isNotEmpty) {
      try {
        data['data'] = jsonEncode(widget.item.productCategory.attributesData);
      } catch (e) {}
    }

    if (widget.item.id > 0) {
      data['id'] = widget.item.id;
      data['is_edit'] = 'Yes';
      data['local_id'] = Utils.getUniqueText();
    } else {
      data['is_edit'] = 'No';
      widget.item.local_id = Utils.getUniqueText();
    }

    data['has_sizes'] = widget.item.has_sizes;
    data['has_colors'] = widget.item.has_colors;
    data['colors'] = widget.item.colors;
    data['sizes'] = widget.item.sizes;
    if (widget.item.p_type == 'Yes') {
      if (widget.item.pricesList.isEmpty) {
        Utils.toast('Please add prices');
        setState(() {
          is_loading = false;
        });
        return;
      }
      data['keywords'] = json.encode(widget.item.pricesList);
      data['price_1'] = '';
      data['price_1'] = '';
    } else {
      data['price_1'] = widget.item.price_1;
      data['price_1'] = widget.item.price_2;
      //keywords
      data['keywords'] = '';
    }

    setState(() {
      error_message = '';
    });

    RespondModel? resp;

    try {
      resp = RespondModel(await Utils.http_post('product-create', data));
    } catch (e) {
      Utils.toast('Failed to save product');
      error_message = e.toString();
      setState(() {
        is_loading = false;
      });
      return;
    }
    setState(() {
      is_loading = false;
    });

    if (resp.code != 1) {
      error_message = resp.message;
      Utils.toast(resp.message, color: Colors.red.shade700, isLong: true);
      setState(() {
        is_loading = false;
      });
      return;
    }

    setState(() {
      is_loading = false;
    });

    if (resp.code == 1) {
      Utils.toast(resp.message);
      Utils.toast('Please wait');
      await Product.getOnlineItems();
      Product.getItems();
      Get.back(result: {'done': 'done'});
      //Navigator.pop(context);
      return;
    }

    Utils.toast(resp.message, color: Colors.red.shade700, isLong: true);
  }
}
