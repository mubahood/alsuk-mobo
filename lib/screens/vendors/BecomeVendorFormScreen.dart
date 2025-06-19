import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/MainController.dart';
import '../../data/img.dart';
import '../../data/my_colors.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class BecomeVendorFormScreen extends StatefulWidget {
  LoggedInUserModel loggedInUserModel;

  BecomeVendorFormScreen(this.loggedInUserModel, {super.key});

  @override
  State<BecomeVendorFormScreen> createState() => _BecomeDriverState();
}

class _BecomeDriverState extends State<BecomeVendorFormScreen> {
  final MainController mainController = Get.find<MainController>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        title: const Text('Vendor registration form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: MyColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              MyDivider("Operator Information"),
              FormBuilderTextField(
                name: 'first_name',
                onChanged: (x) {
                  widget.loggedInUserModel.first_name = x.toString();
                },
                initialValue: widget.loggedInUserModel.first_name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(
                    FeatherIcons.user,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FormBuilderTextField(
                name: 'last_name',
                onChanged: (x) {
                  widget.loggedInUserModel.last_name = x.toString();
                },
                textInputAction: TextInputAction.next,
                initialValue: widget.loggedInUserModel.last_name,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(
                    FeatherIcons.user,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FormBuilderTextField(
                name: 'nin',
                onChanged: (x) {
                  widget.loggedInUserModel.campus_id = x.toString();
                },
                initialValue: widget.loggedInUserModel.campus_id,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'National ID Number',
                  prefixIcon: Icon(
                    FeatherIcons.creditCard,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              MyDivider("Business Information"),
              FormBuilderTextField(
                name: 'business_name',
                onChanged: (x) {
                  widget.loggedInUserModel.business_name = x.toString();
                },
                initialValue: widget.loggedInUserModel.business_name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Business Name',
                  prefixIcon: Icon(
                    FeatherIcons.edit2,
                  ),
                ),
              ),
              FormBuilderTextField(
                name: 'business_address',
                onChanged: (x) {
                  widget.loggedInUserModel.business_address = x.toString();
                },
                initialValue: widget.loggedInUserModel.business_address,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Business Address',
                  prefixIcon: Icon(
                    FeatherIcons.mapPin,
                  ),
                ),
              ),
              FormBuilderTextField(
                name: 'business_license',
                onChanged: (x) {
                  widget.loggedInUserModel.business_license_number =
                      x.toString();
                },
                initialValue: widget.loggedInUserModel.business_license_number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Operation License Number',
                  prefixIcon: Icon(
                    FeatherIcons.file,
                  ),
                ),
              ),
              FormBuilderTextField(
                name: 'business_license_issue_authority',
                onChanged: (x) {
                  widget.loggedInUserModel.business_license_issue_authority =
                      x.toString();
                },
                initialValue:
                    widget.loggedInUserModel.business_license_issue_authority,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'License Issue Authority',
                  prefixIcon: Icon(
                    FeatherIcons.shield,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FormBuilderDateTimePicker(
                name: 'business_license_issue_date',
                onChanged: (x) {
                  widget.loggedInUserModel.business_license_issue_date =
                      x.toString();
                },
                initialDate: Utils.toDate(
                    widget.loggedInUserModel.business_license_issue_date),
                lastDate: DateTime.now(),
                inputType: InputType.date,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'License Issue Date',
                  prefixIcon: Icon(
                    FeatherIcons.calendar,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FormBuilderDateTimePicker(
                name: 'business_license_validity',
                onChanged: (x) {
                  widget.loggedInUserModel.business_license_validity =
                      x.toString();
                },
                inputType: InputType.date,
                initialDate: Utils.toDate(
                    widget.loggedInUserModel.business_license_validity),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'License Expiry Date',
                  prefixIcon: Icon(
                    FeatherIcons.calendar,
                  ),
                ),
              ),
              MyDivider('Contact Information'),
              FormBuilderTextField(
                name: 'business_phone_number',
                onChanged: (x) {
                  widget.loggedInUserModel.business_phone_number = x.toString();
                },
                initialValue: widget.loggedInUserModel.business_phone_number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Business Phone Number',
                  prefixIcon: Icon(
                    FeatherIcons.phone,
                  ),
                ),
              ),
              FormBuilderTextField(
                name: 'business_whatsapp',
                onChanged: (x) {
                  widget.loggedInUserModel.business_whatsapp = x.toString();
                },
                initialValue: widget.loggedInUserModel.business_whatsapp,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Whatsapp Number',
                  prefixIcon: Icon(
                    FeatherIcons.messageCircle,
                  ),
                ),
              ),
              FormBuilderTextField(
                name: 'business_whatsapp',
                onChanged: (x) {
                  widget.loggedInUserModel.business_email = x.toString();
                },
                initialValue: widget.loggedInUserModel.business_email,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(
                    FeatherIcons.mail,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FxContainer(
                onTap: () {
                  _show_bottom_sheet_photo();
                },
                border: Border.all(color: Colors.grey.shade700),
                bordered: true,
                child: Row(
                  children: [
                    FxContainer(
                      paddingAll: 0,
                      borderRadiusAll: 10,
                      border: Border.all(color: Colors.grey.shade700),
                      bordered: true,
                      color: CustomTheme.primary,
                      child: image_path.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(image_path),
                                fit: BoxFit.cover,
                                width: Get.width / 4.1,
                                height: Get.width / 4.1,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: widget.loggedInUserModel.business_logo
                                          .length >
                                      4
                                  ? CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                      imageUrl:
                                          "${AppConfig.MAIN_SITE_URL}/storage/${widget.loggedInUserModel.business_logo}",
                                      placeholder: (context, url) =>
                                          ShimmerLoadingWidget(
                                              height: Get.width / 2),
                                      errorWidget: (context, url, error) =>
                                          const Image(
                                        image: AssetImage(
                                          AppConfig.NO_IMAGE,
                                        ),
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      ),
                                    )
                                  : Image.asset(
                                      Img.get('logo.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FxText.titleLarge(
                        widget.loggedInUserModel.business_logo.length > 4
                            ? "Change Business Logo Photo"
                            : "Add Business Logo Photo",
                        textAlign: TextAlign.center,
                        fontWeight: 800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              error_message.isNotEmpty
                  ? FxText.bodyLarge(
                      error_message,
                      fontWeight: 800,
                      color: Colors.red,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              const SizedBox(
                height: 15,
              ),
              is_loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.accent,
                      ),
                    )
                  : FxButton.block(
                      onPressed: do_register,
                      child: FxText.titleLarge(
                        "SUBMIT",
                        fontWeight: 800,
                        color: Colors.white,
                      )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool is_loading = false;
  String error_message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void refresh_status() async {
    Utils.toast("Refreshing Status...");
    setState(() {
      is_loading = true;
    });
    await LoggedInUserModel.getOnlineItems();
    await mainController.getLoggedInUser();
    if (mainController.userModel.user_type == 'Vendor') {
      Utils.toast("You are now approved as a driver!");
      setState(() {
        is_loading = false;
      });
    }
    setState(() {
      is_loading = false;
    });
  }

  String image_path = "";

  Future<void> _show_bottom_sheet_photo() async {
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
                        do_pick_image("camera");
                      },
                      dense: false,
                      leading:
                          const Icon(Icons.camera_alt, color: MyColors.primary),
                      title: FxText.bodyLarge("Use Camera", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          do_pick_image("gallery");
                        },
                        leading: const Icon(Icons.photo_library_sharp,
                            color: MyColors.primary),
                        title: FxText.bodyLarge("Pick from Gallery",
                            fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  do_pick_image(String source) async {
    Utils.toast(source);

    final ImagePicker picker = ImagePicker();
    if (source == "camera") {
      final XFile? pic =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
      if (pic != null) {
        image_path = pic.path;
        setState(() {});
      }
    } else {
      final XFile? pic = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      if (pic != null) {
        image_path = pic.path;
        setState(() {});
      }
    }
  }

  void do_register() async {
    setState(() {
      is_loading = true;
      error_message = '';
    });

    if (image_path.isEmpty && widget.loggedInUserModel.business_logo.isEmpty) {
      Utils.toast("Please select a photo of your business logo");
      setState(() {
        is_loading = false;
      });
      return;
    }

    if (widget.loggedInUserModel.first_name.isEmpty) {
      Utils.toast("Please enter your first name");
      setState(() {
        is_loading = false;
      });
      return;
    }
    if (widget.loggedInUserModel.last_name.isEmpty) {
      Utils.toast("Please enter your last name");
      setState(() {
        is_loading = false;
      });
      return;
    }

    if (widget.loggedInUserModel.business_name.isEmpty) {
      Utils.toast("Please enter your national ID number");
      setState(() {
        is_loading = false;
      });
      return;
    }

    setState(() {
      is_loading = true;
    });

    Map<String, dynamic> formDataMap = {};

    formDataMap = widget.loggedInUserModel.toJson();

    formDataMap['id'] = widget.loggedInUserModel.id.toString();

    if (image_path.isNotEmpty) {
      try {
        formDataMap['file'] =
            await dio.MultipartFile.fromFile(image_path, filename: image_path);
      } catch (e) {}
    }

    error_message = '';
    setState(() {});
    RespondModel respond =
        RespondModel(await Utils.http_post('become-vendor', formDataMap));
    error_message = respond.message;

    setState(() {
      is_loading = false;
    });

    if (respond.code != 1) {
      Utils.toast(respond.message);
      error_message = respond.message;
      setState(() {
        is_loading = false;
      });
      return;
    }
    Utils.toast(respond.message);
    setState(() {
      is_loading = true;
      error_message = '';
    });
    await LoggedInUserModel.getOnlineItems();
    await Future.delayed(const Duration(seconds: 1));
    await mainController.getLoggedInUser();

    Navigator.pop(context, 'success');
    setState(() {
      is_loading = false;
      error_message = '';
    });

    return;
    if (mainController.userModel.status != '2') {
      Utils.toast("You are not a driver yet. Wait for admin to approve you.");
      setState(() {
        is_loading = false;
      });
      return;
    }

    setState(() {
      is_loading = false;
      error_message = '';
    });
  }
}
