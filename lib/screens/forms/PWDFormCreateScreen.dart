/*
* File : Login
* Version : 1.0.0
* */

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as DioObj;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nudipu/models/RespondModel.dart';
import 'package:nudipu/sections/widgets.dart';
import 'package:nudipu/utils/AppConfig.dart';

import '../../models/Disability.dart';
import '../../models/GroupModel.dart';
import '../../models/LoactionModel.dart';
import '../../models/OptionPickerModel.dart';
import '../../models/Person.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../OtherPages/single_option_picker.dart';

class PWDFormCreateScreen extends StatefulWidget {
  const PWDFormCreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PWDFormCreateScreenState createState() => _PWDFormCreateScreenState();
}

class _PWDFormCreateScreenState extends State<PWDFormCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  Person item = Person();

  @override
  void initState() {
    initFuture = init();
    super.initState();
  }

  init() async {
    return 'dON';
  }

  List<Disability> disabilities = [];

  Future<void> submit_form({
    bool announceChanges = false,
    bool askReset = false,
  }) async {

    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }
    error_message = "";
    setState(() {
      onLoading = true;
    });

    print("PLEASE WAINT...");

    Map<String, dynamic> formDataMap = item.toJson();
    if (local_image_path.isNotEmpty) {
      formDataMap['file'] = await DioObj.MultipartFile.fromFile(
          local_image_path,
          filename: local_image_path);
    }


    RespondModel r = RespondModel(
        await Utils.http_post('people', formDataMap));




    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color :Colors.red);
      error_message = r.message;
      setState(() {
        onLoading = false;
      });
      return;
    }

    await Person.getItems();
    await Person.getItems();

    setState(() {
      onLoading = false;
    });
    Get.back();
    Utils.toast( r.message);

    return;
  }

  void resetForm() {
    setState(() {});

    _formKey.currentState!.patchValue({
      'finance_category_text': '',
      'amount': '',
      'description': '',
    });

    setState(() {});
  }

  var initFuture;

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
          "Registering a new person with disability.",
          color :Colors.white,
          maxLines: 2,
        ),
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: [
                Container(
                    color :Colors.white,
                    padding: EdgeInsets.only(
                        left: MySize.size16, right: MySize.size16),
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MySize.size10,
                            left: MySize.size5,
                            right: MySize.size5,
                            bottom: MySize.size10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            title_widget_2('BIO DATA'),
                            const SizedBox(
                              height: 15,
                            ),
                            FxText.titleLarge(
                              'Photo of a person with disability',
                              fontWeight : 700,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                showImagePicker(context);
                              },
                              child: FxContainer(
                                height: Get.width / 1.8,
                                borderColor: CustomTheme.primaryDark,
                                bordered: true,
                                color :CustomTheme.primaryDark.withAlpha(40),
                                child: local_image_path.isNotEmpty
                                    ? Image.file(
                                        File(local_image_path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        imageUrl: item.photo,
                                        placeholder: (context, url) =>
                                            ShimmerLoadingWidget(
                                          height: double.infinity,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: FxContainer(
                                              color :CustomTheme.primaryDark,
                                              borderRadiusAll: 100,
                                              paddingAll: 20,
                                              child: Icon(
                                                FeatherIcons.camera,
                                                size: Get.width / 6,
                                                color :Colors.white,
                                              )),
                                        ),
                                      ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 20),
                              child: FormBuilderTextField(
                                name: 'name',
                                initialValue: item.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.name = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Full name ",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Full name is required.",
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(height: 15),
                            FormBuilderChoiceChip<String>(
                              decoration: AppTheme.InputDecorationTheme1(
                                  label: "Sex", isDense: true),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: 'sex',
                              padding: const EdgeInsets.all(0),
                              elevation: 1,
                              initialValue: item.sex,
                              onChanged: (x) {
                                item.sex = Utils.to_str(x, '');
                                setState(() {});
                              },
                              backgroundColor:
                                  CupertinoColors.lightBackgroundGray,
                              labelPadding: const EdgeInsets.only(left: 6, right: 6),
                              alignment: WrapAlignment.spaceEvenly,
                              selectedColor: (item.sex == 'Male')
                                  ? Colors.green.shade700
                                  : Colors.green.shade700,
                              options: [
                                FormBuilderChipOption(
                                  value: 'Male',
                                  child: FxText(
                                    "Male",
                                    color :item.sex == 'Male'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                FormBuilderChipOption(
                                  value: 'Female',
                                  child: FxText(
                                    "Female",
                                    color :item.sex == 'Female'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              decoration: AppTheme.InputDecorationTheme1(
                                label: 'Date of birth',
                              ),
                              inputType: InputType.date,
                              name: 'dob',
                              onChanged: (x) {
                                item.dob = Utils.to_str(x, '');
                              },
                              initialDate: DateTime(1990),
                              initialValue: item.dob.isEmpty
                                  ? DateTime(1990)
                                  : Utils.toDate(item.dob),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Disability",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              readOnly: true,
                              onTap: pick_disability,
                              initialValue: item.disability_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "disability_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderChoiceChip<String>(
                              decoration: AppTheme.InputDecorationTheme1(
                                  label:
                                      "Does this person belong to any association/group?",
                                  isDense: true),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: 'has_group',
                              padding: const EdgeInsets.all(0),
                              elevation: 1,
                              initialValue: item.has_group,
                              onChanged: (x) {
                                item.has_group = Utils.to_str(x, '');
                                setState(() {});
                              },
                              backgroundColor:
                                  CupertinoColors.lightBackgroundGray,
                              labelPadding: const EdgeInsets.only(left: 6, right: 6),
                              alignment: WrapAlignment.spaceEvenly,
                              selectedColor: (item.has_group == 'Yes')
                                  ? Colors.green.shade700
                                  : Colors.green.shade700,
                              options: [
                                FormBuilderChipOption(
                                  value: 'Yes',
                                  child: FxText(
                                    "Yes",
                                    color :item.has_group == 'Yes'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                FormBuilderChipOption(
                                  value: 'No',
                                  child: FxText(
                                    "No",
                                    color :item.has_group == 'No'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            (item.has_group == 'Yes')
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Select Association / Group",
                                        ),
                                        validator: MyWidgets
                                            .my_validator_field_required(
                                                context, 'This field '),
                                        readOnly: true,
                                        onTap: pick_group,
                                        initialValue: item.group_text,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        name: "group_text",
                                        textInputAction: TextInputAction.next,
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            FormBuilderDropdown<String>(
                              name: 'education_level',
                              dropdownColor: Colors.white,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Education level",
                              ),
                              onChanged: (x) {
                                String y = x.toString();
                                item.education_level = y;
                                setState(() {});
                              },
                              isDense: true,
                              items: AppConfig.EDUCATION_LEVELS
                                  .map((sub) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        value: sub,
                                        child: Text(sub),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderChoiceChip<String>(
                              decoration: AppTheme.InputDecorationTheme1(
                                  label: "Employment status", isDense: true),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: 'employment_status',
                              padding: const EdgeInsets.all(0),
                              elevation: 1,
                              initialValue: item.employment_status,
                              onChanged: (x) {
                                item.employment_status = Utils.to_str(x, '');
                                setState(() {});
                              },
                              backgroundColor:
                                  CupertinoColors.lightBackgroundGray,
                              labelPadding: const EdgeInsets.only(left: 6, right: 6),
                              alignment: WrapAlignment.spaceEvenly,
                              selectedColor:
                                  (item.employment_status == 'Employed')
                                      ? Colors.green.shade700
                                      : Colors.green.shade700,
                              options: [
                                FormBuilderChipOption(
                                  value: 'Employed',
                                  child: FxText(
                                    "Employed",
                                    color :item.employment_status == 'Employed'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                FormBuilderChipOption(
                                  value: 'Not Employed',
                                  child: FxText(
                                    "Not Employed",
                                    color :
                                        item.employment_status == 'Not Employed'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            title_widget_2('CONTACT information'),
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: FormBuilderTextField(
                                name: 'phone_number',
                                initialValue: item.phone_number,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.phone_number = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.phone,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Phone number ",
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15, top: 0),
                              child: FormBuilderTextField(
                                name: 'phone_number_2',
                                initialValue: item.phone_number_2,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.phone_number_2 = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.phone,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Alternative phone number",
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15, top: 0),
                              child: FormBuilderTextField(
                                name: 'email',
                                initialValue: item.email,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.email = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Email address",
                                ),
                              ),
                            ),
                            title_widget_2('ADDRESS'),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Sub county",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              readOnly: true,
                              onTap: pick_subcounty,
                              initialValue: item.subcounty_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "subcounty_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'parish',
                              initialValue: item.parish,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onChanged: (x) {
                                item.parish = Utils.to_str(x, '');
                              },
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Parish",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'village',
                              initialValue: item.village,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onChanged: (x) {
                                item.village = Utils.to_str(x, '');
                              },
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Village",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'Address line',
                              initialValue: item.address,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onChanged: (x) {
                                item.address = Utils.to_str(x, '');
                              },
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Address",
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            title_widget_2('CAREGIVER INFORMATION'),
                            const SizedBox(
                              height: 25,
                            ),
                            FormBuilderChoiceChip<String>(
                              decoration: AppTheme.InputDecorationTheme1(
                                  label: "Does this person have a caregiver?",
                                  isDense: true),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: 'has_caregiver',
                              padding: const EdgeInsets.all(0),
                              elevation: 1,
                              initialValue: item.has_caregiver,
                              onChanged: (x) {
                                item.has_caregiver = Utils.to_str(x, '');
                                setState(() {});
                              },
                              backgroundColor:
                                  CupertinoColors.lightBackgroundGray,
                              labelPadding: const EdgeInsets.only(left: 6, right: 6),
                              alignment: WrapAlignment.spaceEvenly,
                              selectedColor: (item.has_caregiver == 'Yes')
                                  ? Colors.green.shade700
                                  : Colors.green.shade700,
                              options: [
                                FormBuilderChipOption(
                                  value: 'Yes',
                                  child: FxText(
                                    "Yes",
                                    color :item.has_caregiver == 'Yes'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                FormBuilderChipOption(
                                  value: 'No',
                                  child: FxText(
                                    "No",
                                    color :item.employment_status == 'No'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            item.has_caregiver != 'Yes'
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      FormBuilderTextField(
                                        name: 'caregiver_name',
                                        initialValue: item.caregiver_name,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (x) {
                                          item.caregiver_name =
                                              Utils.to_str(x, '');
                                        },
                                        keyboardType: TextInputType.name,
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Caregiver full name",
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      FormBuilderChoiceChip<String>(
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                                label: "Caregiver Sex",
                                                isDense: true),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        name: 'caregiver_sex',
                                        padding: const EdgeInsets.all(0),
                                        elevation: 1,
                                        initialValue: item.caregiver_sex,
                                        onChanged: (x) {
                                          item.caregiver_sex =
                                              Utils.to_str(x, '');
                                          setState(() {});
                                        },
                                        backgroundColor:
                                            CupertinoColors.lightBackgroundGray,
                                        labelPadding:
                                            const EdgeInsets.only(left: 6, right: 6),
                                        alignment: WrapAlignment.spaceEvenly,
                                        selectedColor:
                                            (item.caregiver_sex == 'Male')
                                                ? Colors.green.shade700
                                                : Colors.green.shade700,
                                        options: [
                                          FormBuilderChipOption(
                                            value: 'Male',
                                            child: FxText(
                                              "Male",
                                              color :
                                                  item.caregiver_sex == 'Male'
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                          FormBuilderChipOption(
                                            value: 'Female',
                                            child: FxText(
                                              "Female",
                                              color :
                                                  item.caregiver_sex == 'Female'
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'caregiver_age',
                                        initialValue: item.caregiver_age,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (x) {
                                          item.caregiver_age =
                                              Utils.to_str(x, '');
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Caregiver age",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'caregiver_relationship',
                                        initialValue:
                                            item.caregiver_relationship,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (x) {
                                          item.caregiver_relationship =
                                              Utils.to_str(x, '');
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label:
                                              "Relationship with this person",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'caregiver_phone_number',
                                        initialValue:
                                            item.caregiver_phone_number,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (x) {
                                          item.caregiver_phone_number =
                                              Utils.to_str(x, '');
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Caregiver phone number",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                            alertWidget(error_message, 'success'),
                            onLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            CustomTheme.primary),
                                      ),
                                    ))
                                : FxButton.block(
                                    onPressed: () {
                                      submit_form();
                                    },
                                    borderRadiusAll: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          size: 30,
                                          color :Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Center(
                                            child: FxText.titleLarge(
                                          "SUBMIT",
                                          color :Colors.white,
                                          fontWeight : 700,
                                        )),
                                      ],
                                    ))
                          ],
                        ),
                      ),
                    )),
              ],
            );
          }),
    );
  }

  List<OptionPickerModel> selectedLocations = [];
  List<LocarionModel> locations = [];
  List<GroupModel> groups = [];
  List<OptionPickerModel> subs = [];
  bool is_loading = false;

  pick_group() async {
    setState(() {
      is_loading = true;
    });

    if (groups.isEmpty) {
      groups = await GroupModel.getItems();
    }

    subs.clear();
    for (var element in groups) {
      OptionPickerModel item = OptionPickerModel();
      item.parent_id = "1";
      item.id = element.id.toString();
      item.name = "${element.name}, ${element.group_name}";
      subs.add(item);
    }

    setState(() {
      is_loading = false;
    });

    selectedLocations.clear();
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleOptionPicker(
              "Select a group", subs, selectedLocations, true)),
    );
    setState(() {
      is_loading = false;
    });

    if (result.runtimeType.toString() == 'List<OptionPickerModel>') {
      List<OptionPickerModel> r = result;
      if (r.isNotEmpty && Utils.int_parse(r.first.id) > 0) {
        item.group_id = r.first.id.toString();
        item.group_text = r.first.name.toString();
        _formKey.currentState!.patchValue({
          'group_text': item.group_text,
        });
        setState(() {});
      }
    }
  }

  pick_disability() async {
    if (is_loading) {
      return;
    }
    setState(() {
      is_loading = true;
    });

    if (disabilities.isEmpty) {
      disabilities = await Disability.getItems();
    }

    subs.clear();
    for (var element in disabilities) {
      OptionPickerModel item = OptionPickerModel();
      item.parent_id = "1";
      item.id = element.id.toString();
      item.name = element.name.toString();
      subs.add(item);
    }

    setState(() {
      is_loading = false;
    });

    selectedLocations.clear();
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleOptionPicker(
              "Select a disability", subs, selectedLocations, true)),
    );
    setState(() {
      is_loading = false;
    });

    if (result.runtimeType.toString() == 'List<OptionPickerModel>') {
      List<OptionPickerModel> r = result;
      if (r.isNotEmpty && Utils.int_parse(r.first.id) > 0) {
        item.disability_id = r.first.id.toString();
        item.disability_text = r.first.name.toString();
        _formKey.currentState!.patchValue({
          'disability_text': item.disability_text,
        });
        setState(() {});
      }
    }
  }

  pick_subcounty() async {
    if (is_loading) {
      return;
    }
    setState(() {
      is_loading = true;
    });

    if (locations.length < 4) {
      locations = await LocarionModel.get_items(false);
    }

    if (subs.length < 2) {
      subs.clear();
      for (var element in locations) {
        OptionPickerModel item = OptionPickerModel();
        item.parent_id = "1";
        item.id = element.id.toString();
        item.name = element.name.toString();
        subs.add(item);
      }
    }

    setState(() {
      is_loading = false;
    });

    selectedLocations.clear();
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleOptionPicker(
              "Select sub-county", subs, selectedLocations, true)),
    );
    setState(() {
      is_loading = false;
    });

    if (result.runtimeType.toString() == 'List<OptionPickerModel>') {
      List<OptionPickerModel> r = result;
      if (r.isNotEmpty && Utils.int_parse(r.first.id) > 0) {
        item.subcounty_id = r.first.id.toString();
        item.subcounty_text = r.first.name.toString();
        print(item.subcounty_text);
        _formKey.currentState!.patchValue({
          'subcounty_text': item.subcounty_text,
        });
        setState(() {});
      }
    }
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            color :Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color :Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _onImageButtonPressed(ImageSource.camera);
                      },
                      dense: false,
                      leading: const Icon(FeatherIcons.camera,
                          size: 30, color :CustomTheme.primary),
                      title: FxText(
                        "Use camera",
                        fontWeight : 500,
                        color :Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          _onImageButtonPressed(ImageSource.gallery);
                        },
                        leading: const Icon(FeatherIcons.image,
                            size: 28, color :CustomTheme.primary),
                        title: FxText(
                          "Pick from gallery",
                          fontWeight : 500,
                          color :Colors.black,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  Future<void> _onImageButtonPressed(
    ImageSource source,
  ) async {
    try {
      pickedFile = await _picker.pickImage(source: source, imageQuality: 40);
      displayPickedPhoto();
    } catch (e) {
      Utils.toast("Failed to get photo because $e");
    }
  }

  String local_image_path = "";

  Future<void> displayPickedPhoto() async {
    if (pickedFile == null) {
      return;
    }
    if (pickedFile?.path == null) {
      return;
    }
    if (pickedFile?.name == null) {
      return;
    }

    var tempFile = pickedFile?.path.toString();
    if (!(await (File(tempFile.toString()).exists()))) {
      return;
    }
    local_image_path = tempFile.toString();
    setState(() {});
  }
}
