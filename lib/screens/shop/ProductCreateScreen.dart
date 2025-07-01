import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nudipu/models/ImageModelLocal.dart';
import 'package:nudipu/models/RespondModel.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/Utils.dart';
import '../../controllers/MainController.dart';
import '../../models/Product.dart';
import '../../models/ProductCategory.dart';
import '../../sections/widgets.dart';
import '../../utils/AppConfig.dart';
import '../../utils/SizeConfig.dart';
import 'HtmlEditorScreen.dart';
import 'ProductCreateScreen2.dart';

class ProductCreateScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  ProductCreateScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  CaseCreateBasicState createState() => CaseCreateBasicState();
}

class CaseCreateBasicState extends State<ProductCreateScreen>
    with SingleTickerProviderStateMixin {
  Product item = Product();

  CaseCreateBasicState();

  bool is_loading = false;

  bool mainLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.params['item'] != null) {
      if (item.runtimeType == widget.params['item'].runtimeType) {
        item = widget.params['item'];
        if (item.id > 0) {
          isEdit = true;
        }
      }
    }
    if (item.local_id.length < 3) {
      item.local_id = Utils.getUniqueText();
    }
    futureInit = my_init();
  }

  Future<dynamic> my_init() async {
    if (mainController.userModel.id < 1) {
      Utils.toast("Please login first");
      Navigator.pop(context);
      return;
    }

    if (item.category.isNotEmpty) {
      List<ProductCategory> tempCats =
          await ProductCategory.getItems(where: 'id = ${item.category}');
      if (tempCats.isNotEmpty) {
        category = tempCats[0];
        item.productCategory = tempCats[0];
      }
    }
    if (isEdit) {
      item.getOnlinePhotos();
      setState(() {});
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
        middleText: "Are you sure you want quit adding/updating new product?",
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey.shade200,
          systemOverlayStyle: Utils.overlay(),
          elevation: 0,
          title: FxText.titleLarge(
            "Uploading product",
            color: Colors.black,
            fontWeight: 900,
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
      ),
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
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText(
                                    'More Details',
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  addPhotos();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    color: CustomTheme.primary.withAlpha(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.camera_alt_outlined,
                                          size: 30, color: CustomTheme.primary),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                          child: FxText.bodyMedium(
                                        "Add product's photos",
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: 700,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              photosToUpload.isEmpty
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 120.0,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: photosToUpload.length,
                                        itemBuilder: (context, index) {
                                          return single_image_ui(
                                              photosToUpload[index], index);
                                        },
                                      ),
                                    ),
                              (!isEdit)
                                  ? const SizedBox()
                                  : item.online_photos.isEmpty
                                      ? const SizedBox()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FxText.titleLarge('Uploaded photos',
                                                fontWeight: 900,
                                                color: Colors.black),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 120.0,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    item.online_photos.length,
                                                itemBuilder: (context, index) {
                                                  return single_image_ui_online(
                                                      item.online_photos[index]
                                                          .src,
                                                      index);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Product name',
                                ),
                                initialValue: item.name,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                name: 'name',
                                onChanged: (x) {
                                  item.name = x.toString();
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Name is required.",
                                  ),
                                  FormBuilderValidators.min(
                                    1,
                                    errorText: "Name is required",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Contact Phone Number',
                                ),
                                keyboardType: TextInputType.phone,
                                name: 'url',
                                onChanged: (x) {
                                  item.url = x.toString();
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Phone number is required.",
                                  ),
                                  FormBuilderValidators.minLength(
                                    5,
                                    errorText:
                                        "Phone number should be at least 5 digits.",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                    labelText: 'Product/Service Address'),
                                keyboardType: TextInputType.streetAddress,
                                name: 'supplier',
                                onChanged: (x) {
                                  item.supplier = x.toString();
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Address is required.",
                                  ),
                                  FormBuilderValidators.minLength(
                                    5,
                                    errorText:
                                        "Address should be at least 5 characters.",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              FormBuilderTextField(
                                decoration: CustomTheme.input_decoration(
                                  labelText: 'Product category',
                                ),
                                readOnly: true,
                                onTap: () async {
                                  mainController.getCategories();
                                  showBottomSheetCategoryPicker();
                                },
                                keyboardType: TextInputType.text,
                                name: 'category_text',
                                initialValue: item.category_text,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Category is required.",
                                  ),
                                ]),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Column(
                                children: [
                                  FormBuilderTextField(
                                          decoration:
                                              CustomTheme.input_decoration(
                                            labelText:
                                                'Original price (${AppConfig.CURRENCY})',
                                          ),
                                          initialValue: item.price_2,
                                          keyboardType: TextInputType.number,
                                          name: 'price_2',
                                          onChanged: (x) {
                                            item.price_2 = x.toString();
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                              errorText: "Price is required.",
                                            ),
                                            FormBuilderValidators.min(
                                              1,
                                              errorText:
                                                  "Price should be at least 1.",
                                            ),
                                          ]),
                                          textInputAction: TextInputAction.next,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        FormBuilderTextField(
                                          decoration:
                                              CustomTheme.input_decoration(
                                            labelText:
                                                'Selling price (${AppConfig.CURRENCY})',
                                          ),
                                          keyboardType: TextInputType.number,
                                          name: 'price_1',
                                          onChanged: (x) {
                                            item.price_1 = x.toString();
                                          },
                                          initialValue: item.price_1,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                              errorText: "Price is required.",
                                            ),
                                            FormBuilderValidators.min(
                                              1,
                                              errorText:
                                                  "Price should be at least 1KG.",
                                            ),
                                          ]),
                                          textInputAction: TextInputAction.next,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                              ),
                              FxContainer(
                                onTap: () async {
                                  var resp = await Get.to(() =>
                                      HtmlEditorScreen(
                                          data: item.description,
                                          title: 'Editor'));

                                  if (resp != null) {
                                    item.description = resp.toString();
                                  }
                                  setState(() {});
                                  return;
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                bordered: true,
                                border: Border.all(
                                    color: Colors.grey.shade700,
                                    width: 2,
                                    style: BorderStyle.solid),
                                color: CustomTheme.bg_primary_light,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FxText.titleLarge('Product Description',
                                        fontWeight: 900, color: Colors.black),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                    Html(
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
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _keyboardVisible
                        ? const SizedBox()
                        : FxContainer(
                            color: Colors.white,
                            borderRadiusAll: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: FxButton.block(
                                onPressed: () async {
                                  submit();
                                },
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: CustomTheme.primary,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FxText.titleLarge(
                                      'NEXT',
                                      color: Colors.white,
                                      fontWeight: 800,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(FeatherIcons.arrowRight)
                                  ],
                                ))),
                  ],
                ),
        ],
      ),
    );
  }

  Future<void> addPhotos() async {
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
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        do_pick_image_from_camera();
                      },
                      dense: false,
                      leading: const Icon(Icons.camera_alt_outlined,
                          size: 28, color: CustomTheme.primary),
                      title: FxText.bodyLarge(
                        "Use camera",
                        fontWeight: 500,
                        fontSize: 18,
                      ),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          do_pick_image_from_gallary();
                        },
                        leading: const Icon(Icons.photo_library_outlined,
                            size: 28, color: CustomTheme.primary),
                        title: FxText.bodyLarge(
                          "Pick from gallery",
                          fontWeight: 500,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  do_pick_image_from_camera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pic = await picker.pickImage(source: ImageSource.camera);
    if (pic != null) {
      await saveLocalImage(pic.path);
    }

    await getItemImages();
    isUploading = false;
    uploadPics();
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
    isUploading = false;
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

  single_image_ui_online(String m, int index) {
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
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: '${AppConfig.DASHBOARD_URL}/storage/$m',
            placeholder: (context, url) => ShimmerLoadingWidget(
              height: 120,
            ),
            errorWidget: (context, url, error) => const Image(
              image: AssetImage('no_image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            right: 0,
            child: InkWell(
              onTap: () {
                Get.defaultDialog(
                    middleText: "Are you sure you want to delete this image?",
                    titleStyle: const TextStyle(color: Colors.black),
                    actions: <Widget>[
                      FxButton.outlined(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        borderColor: CustomTheme.primary,
                        child: FxText(
                          'CANCEL',
                          color: CustomTheme.primary,
                        ),
                      ),
                      FxButton.small(
                        backgroundColor: Colors.red,
                        onPressed: () async {
                          Navigator.pop(context);
                          Utils.toast("Deleting...");
                          RespondModel resp = RespondModel(
                              await Utils.http_post("images-delete", {
                            'id': item.online_photos[index].id.toString(),
                          }));

                          if (resp.code != 1) {
                            Utils.toast(resp.message, color: Colors.red);
                            return;
                          }
                          Utils.toast(resp.message, color: Colors.green);
                          item.online_photos.removeAt(index);

                          //item.online_photos.removeAt(index);
                          setState(() {});
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: FxText(
                          'DELETE',
                          color: Colors.white,
                        ),
                      )
                    ]);
              },
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
            )),
      ],
    );
  }

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

  bool isUploading = false;

  uploadPics() async {
    if (isUploading) {
      return;
    }
    isUploading = true;
    for (var x in item.local_photos) {
      if (uploadedPics.contains(x.src)) {
        continue;
      }
      if (await x.uploadSelf()) {
        uploadedPics.add(x.src);
      }
      setState(() {});
      isUploading = false;
      uploadPics();
      break;
    }
  }

  saveLocalImage(String path) async {
    if (item.local_id.length < 3) {
      item.local_id = Utils.getUniqueText();
    }
    ImageModel img = ImageModel();
    img.type = 'Product';
    img.src = path;
    img.parent_id = item.id.toString();
    img.parent_local_id = item.local_id.toString();
    photosToUpload.add(img.src);
    await img.save();
    item.local_photos.add(img);
    setState(() {});
  }

  getItemImages() {}

  removeImage(String m, int index) async {
    photosToUpload.removeAt(index);
    setState(() {});
    for (var x in item.local_photos) {
      if (x.src == m) {
        item.local_photos.removeAt(index);
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
    if (category.id < 1) {
      Utils.toast("Please select a category.");
      return;
    }
    if (item.local_photos.isEmpty && item.online_photos.isEmpty) {
      Utils.toast("Please add at least one image.");
      return;
    }

    if (Utils.int_parse(item.price_2) < Utils.int_parse(item.price_1)) {
      Utils.toast("Original price should be greater than product price.");
      return;
    }

    //validate sizes
    if (item.has_sizes == 'Yes') {
      if (item.sizesList.isEmpty) {
        Utils.toast("Please add at least one size.");
        return;
      }
    }

    //validate colors
    if (item.has_colors == 'Yes') {
      if (item.colorList.isEmpty) {
        Utils.toast("Please add at least one color.");
        return;
      }
    }

    //validate prices
    if (item.p_type == 'Yes') {
      if (item.pricesList.isEmpty) {
        Utils.toast("Please add at least one price.");
        return;
      }
    }

    item.productCategory = category;
    item.category = category.id.toString();
    item.productCategory.getAttributesList();
    isUploading = false;
    uploadPics();
    setState(() {});
    var data = await Get.to(() => ProductCreateScreen2(item));
    if (data != null) {
      if (data['done'] == 'done') {
        Get.back(result: {'done': 'done'});
      }
    }
    return;
  }
}
