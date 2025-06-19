import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:nudipu/utils/Utils.dart';

import '../../controllers/MainController.dart';
import '../../models/DeliveryAddress.dart';
import '../../models/OrderOnline.dart';
import '../../models/Product.dart';
import '../../sections/widgets.dart';
import '../../utils/my_widgets.dart';
import '../pickers/DeliveryAddressPickerScreen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  OrderOnline order = OrderOnline();

  DeliveryAddressScreen(this.order, {Key? key}) : super(key: key);

  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    is_loading = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Delivery Address",
          color: Colors.white,
          maxLines: 2,
          fontWeight: 800,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return myListLoaderWidget(context);
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  final _fKey = GlobalKey<FormBuilderState>();
  String error_message = "";
  bool is_loading = false;

  submitOrder() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    return;
  }

  Widget mainWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _fKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Select a delivery region",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: widget.order.delivery_address_text,
                              onTap: () async {
                                /*widget.order.delivery_address_text*/
                                DeliveryAddress? d = await Get.to(
                                    () => const DeliveryAddressPickerScreen());
                                if (d == null) {
                                  Utils.toast('Address not selected',
                                      color: CustomTheme.red);
                                  return;
                                }
                                widget.order.delivery_address_text = d.address;
                                widget.order.delivery_amount = d.shipping_cost;
                                widget.order.delivery_address_id =
                                    d.id.toString();

                                _fKey.currentState!.patchValue({
                                  'delivery_address_text':
                                      "${widget.order.delivery_address_text} (ZAR ${Utils.moneyFormat(widget.order.delivery_amount)})"
                                });

                                setState(() {});
                              },
                              readOnly: true,
                              textCapitalization: TextCapitalization.words,
                              name: "delivery_address_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Street Address",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue:
                              widget.order.delivery_address_details,
                              onChanged: (x) {
                                widget.order.delivery_address_details =
                                    x.toString();
                                widget.order.customer_address = x.toString();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "delivery_address_details",
                              textInputAction: TextInputAction.next,
                            ),
                           /* FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Postal code",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: widget.order.description,
                              onChanged: (x) {
                                widget.order.description = x.toString();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "description",
                              textInputAction: TextInputAction.next,
                            ),*/

                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Name",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: widget.order.customer_name,
                              onChanged: (x) {
                                widget.order.customer_name = x.toString();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "customer_name",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Email address",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: widget.order.mail,
                              onChanged: (x) {
                                widget.order.mail = x.toString();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "mail",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Phone number",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue:
                                  widget.order.customer_phone_number_1.trim(),
                              onChanged: (x) {
                                widget.order.customer_phone_number_1 =
                                    x.toString().trim();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "customer_phone_number_1",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Alternate phone number",
                              ),
                              initialValue:
                                  widget.order.customer_phone_number_2,
                              onChanged: (x) {
                                widget.order.customer_phone_number_2 =
                                    x.toString();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "customer_phone_number_2",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Order details",
                              ),
                              initialValue: widget.order.order_details,
                              onChanged: (x) {
                                widget.order.order_details = x.toString();
                              },
                              textCapitalization: TextCapitalization.words,
                              name: "order_details",
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FxContainer(
              borderRadiusAll: 0,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: CustomTheme.primary.withAlpha(30),
              child: FxButton(
                  block: true,
                  borderRadiusAll: 5,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  borderColor: CustomTheme.primary,
                  onPressed: () {
                    if (widget.order.delivery_address_id.length < 1) {
                      Utils.toast("Please select delivery region",
                          color: CustomTheme.red);
                      return;
                    }
                    if (widget.order.delivery_address_details.length < 5) {
                      Utils.toast("Please enter a clear address.",
                          color: CustomTheme.red);
                      return;
                    }

                    //check phone number
                    if (widget.order.customer_phone_number_1.length < 10) {
                      Utils.toast("Please enter a valid phone number.",
                          color: CustomTheme.red);
                      return;
                    }
                    //check for email
                    if (!Utils.isValidMail(widget.order.mail)) {
                      Utils.toast("Please enter a valid email address.",
                          color: CustomTheme.red);
                      return;
                    }
                    //check if phone starts with +


                    Get.back();
                  },
                  child: FxText.titleLarge(
                    'DONE',
                    fontWeight: 900,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }

  late Future<dynamic> futureInit;
  MainController mainController = MainController();

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<Product> items = [];

  Future<dynamic> myInit() async {
    await mainController.getCartItems();
    return "Done";
  }

  menuItemWidget(String title, String subTitle, Function screen) {
    return InkWell(
      onTap: () => {screen()},
      child: Container(
        padding: const EdgeInsets.only(left: 0, bottom: 5, top: 20),
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: CustomTheme.primary, width: 2),
        )),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleLarge(
                    title,
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight: 600,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 35,
            )
          ],
        ),
      ),
    );
  }
}
