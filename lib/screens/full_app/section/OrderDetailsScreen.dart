import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/OrderOnline.dart';

import '../../../theme/custom_theme.dart';
import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../../../utils/my_text.dart';
import '../../cart/WebViewExample.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderOnline order;

  OrderDetailsScreen(this.order, {super.key});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen>
    with TickerProviderStateMixin {
  bool expand1 = true, expand2 = false, expand3 = false;
  late AnimationController controller1, controller2, controller3;
  late Animation<double> animation1, animation1View;
  late Animation<double> animation2, animation2View;
  late Animation<double> animation3, animation3View;

  @override
  void initState() {
    super.initState();
    widget.order.get_items_text();
    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation1 = Tween(begin: 0.0, end: 180.0).animate(controller1);
    animation1View = CurvedAnimation(parent: controller1, curve: Curves.linear);

    animation2 = Tween(begin: 0.0, end: 180.0).animate(controller2);
    animation2View = CurvedAnimation(parent: controller2, curve: Curves.linear);

    animation3 = Tween(begin: 0.0, end: 180.0).animate(controller3);
    animation3View = CurvedAnimation(parent: controller3, curve: Curves.linear);

    controller1.forward();
    controller3.forward();
    controller1.addListener(() {
      setState(() {});
    });
    controller2.addListener(() {
      setState(() {});
    });
    controller3.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            systemOverlayStyle: Utils.overlay(),
            title: FxText.titleLarge('Order Details',
                color: Colors.white, fontWeight: 600),
            backgroundColor: CustomTheme.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String value) {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 30.0,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "Pay Order",
                    child: Text("Pay Order"),
                  ),
                  const PopupMenuItem(
                    value: "Cancel Order",
                    child: Text("Cancel Order"),
                  ),
                ],
              )
            ]),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      color: CustomTheme.primary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "${AppConfig.CURRENCY}${Utils.moneyFormat(widget.order.order_total)}",
                              style: MyText.display2(context)!
                                  .copyWith(color: Colors.white)),
                          Row(
                            children: [
                              Text("PAYMENT STATUS:",
                                  style: MyText.body1(context)!
                                      .copyWith(color: Colors.white)),
                              const SizedBox(width: 5),
                              FxContainer(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                borderRadiusAll: 100,
                                color: widget.order.isPaid()
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                child: FxText.bodySmall(
                                  widget.order.isPaid() ? "Paid" : "Not Paid",
                                  color: Colors.white,
                                  fontWeight: 600,
                                ),
                              )
                            ],
                          ),
                          Container(height: 25),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("INVOICE-${widget.order.id}",
                                      style: MyText.headline(context)!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      Text("ORDER STATUS:",
                                          style: MyText.body1(context)!
                                              .copyWith(color: Colors.white)),
                                      const SizedBox(width: 5),
                                      FxContainer(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        borderRadiusAll: 100,
                                        color: Colors.white,
                                        child: FxText.bodySmall(
                                          widget.order.getOrderStatus(),
                                          color: Colors.black,
                                          fontWeight: 600,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              FloatingActionButton(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                mini: true,
                                onPressed: () {
                                  //widget.order.prepare();
                                  setState(() {});
                                },
                                child: const Icon(Icons.description,
                                    size: 25.0, color: CustomTheme.primary),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.event,
                              size: 25.0, color: Colors.grey),
                          Container(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(height: 5),
                              Text("Invoice Date",
                                  style: MyText.title(context)!.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400)),
                              Container(height: 20),
                              Text(Utils.to_date(widget.order.created_at),
                                  style: MyText.body1(context)!.copyWith(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[200], height: 0, thickness: 0.5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          Container(width: 15),
                          const Icon(Icons.apps,
                              size: 25.0, color: Colors.grey),
                          Container(width: 20),
                          Text("Items (s)",
                              style: MyText.title(context)!.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                          const Spacer(),
                          Transform.rotate(
                            angle: animation1.value * math.pi / 180,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                togglePanel1();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: animation1View,
                      child: Container(
                        child: Column(
                          children: true
                              ? widget.order.cartItemsObjects
                              : <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(width: 65),
                                      const Text("Web Design"),
                                      const Spacer(),
                                      const Text("\$ 455.62"),
                                      Container(width: 20),
                                    ],
                                  ),
                                  Container(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Container(width: 65),
                                      const Text("E-Book Design"),
                                      const Spacer(),
                                      const Text("\$ 278.12"),
                                      Container(width: 20),
                                    ],
                                  ),
                                  Container(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Container(width: 65),
                                      const Text("Hosting Plan"),
                                      const Spacer(),
                                      const Text("\$ 719.00"),
                                      Container(width: 20),
                                    ],
                                  ),
                                  Container(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Container(width: 65),
                                      const Text("Brochure Design"),
                                      const Spacer(),
                                      const Text("\$ 573.50"),
                                      Container(width: 20),
                                    ],
                                  ),
                                  Container(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(width: 65),
                                      const Text("Total",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      const Text("\$ 2.026.24",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Container(width: 20),
                                    ],
                                  ),
                                  Container(height: 15),
                                ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[200], height: 0, thickness: 0.5),
                    true
                        ? SizedBox()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Row(
                              children: <Widget>[
                                Container(width: 15),
                                const Icon(Icons.insert_drive_file,
                                    size: 25.0, color: Colors.grey),
                                Container(width: 20),
                                Column(
                                  children: <Widget>[
                                    Text("Notes (Messages)",
                                        style: MyText.title(context)!.copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                const Spacer(),
                                Transform.rotate(
                                  angle: animation1.value * math.pi / 180,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      togglePanel2();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                    true
                        ? SizedBox()
                        : SizeTransition(
                            sizeFactor: animation2View,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(width: 65),
                                Flexible(
                                    flex: 1,
                                          child:
                                              Text(widget.order.order_details)),
                                      Container(width: 20)
                                    ],
                            ),
                            Container(height: 15),
                          ],
                        ),
                      ),
                          ),
                    Divider(color: Colors.grey[200], height: 0, thickness: 0.5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          Container(width: 15),
                          const Icon(Icons.location_on,
                              size: 25.0, color: Colors.grey),
                          Container(width: 20),
                          Column(
                            children: <Widget>[
                              Text("Address & Contact",
                                  style: MyText.title(context)!.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const Spacer(),
                          Transform.rotate(
                            angle: animation1.value * math.pi / 180,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                togglePanel3();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: animation3View,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(width: 65),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      "${widget.order.customer_name.trim()},\n${widget.order.customer_phone_number_1}\n${widget.order.customer_phone_number_2}"
                                          .trim()),
                                ),
                                Container(width: 20)
                              ],
                            ),
                            Container(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.order.isPaid())
              Container()
            else
              FxContainer(
                borderRadiusAll: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    FxButton.block(
                        backgroundColor: CustomTheme.primary,
                        borderRadiusAll: 15,
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 14),
                        borderColor: CustomTheme.primary,
                        onPressed: () async {
                          await Get.to(() => WebViewExample('pay_link'));

                        },
                        child: FxText.titleLarge(
                          'PAY ORDER',
                          fontWeight: 900,
                          color: Colors.white,
                        )),
                  ],
                ),
              )
          ],
        ));
  }

  void togglePanel1() {
    if (!expand1) {
      controller1.forward();
    } else {
      controller1.reverse();
    }
    expand1 = !expand1;
  }

  void togglePanel2() {
    if (!expand2) {
      controller2.forward();
    } else {
      controller2.reverse();
    }
    expand2 = !expand2;
  }

  void togglePanel3() {
    if (!expand3) {
      controller3.forward();
    } else {
      controller3.reverse();
    }
    expand3 = !expand3;
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
}
