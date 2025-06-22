import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/controllers/MainController.dart';
import 'package:nudipu/screens/chat/ChatsScreen.dart';
import 'package:nudipu/screens/full_app/section/AccountSection.dart';
import 'package:nudipu/screens/full_app/section/SectionCart.dart';
import 'package:nudipu/screens/full_app/section/SectionDashboard.dart';
import 'package:nudipu/theme/app_theme.dart';

import '../vendors/VendorsScreen.dart';

class FullApp extends StatefulWidget {
  static const String tag = "FullApp";

  const FullApp({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullApp> with SingleTickerProviderStateMixin {
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
            middleText: "Are you sure you want close this App?",
            titleStyle: const TextStyle(color: Colors.black),
            actions: <Widget>[
              FxButton.outlined(
                onPressed: () {
                  //close the app
                  SystemNavigator.pop();
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                borderColor: CustomTheme.primary,
                child: FxText(
                  'CLOSE APP',
                  color: CustomTheme.primary,
                ),
              ),
              FxButton.small(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: FxText(
                  'CANCEL',
                  color: Colors.white,
                ),
              )
            ]);
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: <Widget>[
                  const SectionDashboard(),
                  VendorsScreen(),
                  // const CartScreen(),
                  SectionCart(mainController),
                  const ChatsScreen(),
                  const AccountSection(),
                ],
              ),
            ),
            FxContainer(
              paddingAll: 0,
              bordered: true,
              enableBorderRadius: false,
              border: Border(
                  top: BorderSide(
                      width: 2,
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid)),
              padding: FxSpacing.xy(0, 5),
              marginAll: 0,
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                controller: tabController,
                indicator: const FxTabIndicator(
                  indicatorColor: CustomTheme.primary,
                  indicatorHeight: 2,
                  radius: 4,
                  width: 60,
                  indicatorStyle: FxTabIndicatorStyle.rectangle,
                  yOffset: -7,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: CustomTheme.primary,
                splashBorderRadius: BorderRadius.circular(0),
                tabs: [
                  myNavItem('Home', FeatherIcons.home, 0),
                  myNavItem('Vendors', FeatherIcons.users, 3),
                  myNavItem('SELL NOW', FeatherIcons.plus, 2),
                  myNavItem('Messages', FeatherIcons.messageCircle, 1),
                  myNavItem('Account', FeatherIcons.user, 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  late TabController tabController;

  Widget myNavItem(String title, IconData icon, int i) {
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(
            icon,
            size: title.length < 10 ? 22 : 25,
            color: (tabController.index == i)
                ? CustomTheme.primary
                : Colors.grey[700],
          ),
          const SizedBox(
            height: 3,
          ),
          FxText.bodySmall(
            title,
            fontSize: title.length < 10 ? 12 : 8,
            color: (tabController.index == i)
                ? CustomTheme.primary
                : Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
