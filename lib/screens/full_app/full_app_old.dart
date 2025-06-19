import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/controllers/MainController.dart';
import 'package:nudipu/screens/full_app/section/AccountSection.dart';
import 'package:nudipu/screens/full_app/section/SectionCart.dart';
import 'package:nudipu/screens/full_app/section/SectionDashboard.dart';
import 'package:nudipu/screens/full_app/section/SectionOrders.dart';
import 'package:nudipu/theme/app_theme.dart';

import '../../controllers/full_app_controller.dart';
import '../chat/ChatsScreen.dart';

class FullAppOld extends StatefulWidget {
  static const String tag = "FullApp";

  const FullAppOld({Key? key}) : super(key: key);

  @override
  _FullAppOldState createState() => _FullAppOldState();
}

class _FullAppOldState extends State<FullAppOld>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  late FullAppController controller;
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();

    theme = AppTheme.shoppingTheme;
    controller = FxControllerStore.putOrFind(FullAppController(this));
    mainController.initialized;
    mainController.init();
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];
    for (int i = 0; i < controller.navItems.length; i++) {
      tabs.add(
        Container(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Icon(
                controller.navItems[i].iconData,
                size: controller.navItems[i].title.length < 10 ? 22 : 25,
                color: (controller.currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground,
              ),
              const SizedBox(
                height: 3,
              ),
              FxText.bodySmall(
                controller.navItems[i].title,
                fontSize: controller.navItems[i].title.length < 10 ? 12 : 8,
                color: (controller.currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground,
              ),
            ],
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FullAppController>(
        controller: controller,
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              Get.defaultDialog(
                  middleText: "Are you sure you want close this App?",
                  titleStyle: const TextStyle(color: Colors.black),
                  actions: <Widget>[
                    FxButton.outlined(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: FxText(
                        'CANCEL',
                        color: Colors.white,
                      ),
                    )
                  ]);
              return false;
            },
            child: Scaffold(
              body: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: controller.tabController,
                              children: <Widget>[
                                const SectionDashboard(),
                                const ChatsScreen(),
                                SectionCart(mainController),
                                SectionOrders(),
                                const AccountSection(),
                              ],
                            ),
                          ),
                          FxContainer(
                            bordered: true,
                            enableBorderRadius: false,
                            border: Border(
                                top: BorderSide(
                                    color: theme.dividerColor,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            padding: FxSpacing.xy(0, 5),
                            marginAll: 0,
                            color: theme.scaffoldBackgroundColor,
                            child: TabBar(
                              labelPadding: EdgeInsets.zero,
                              controller: controller.tabController,
                              onTap: (index) {
                                /*if(index == 1){
                                  Get.to(() => const ProductSearchScreen());
                                  controller.tabController.animateTo(0);
                                }*/
                              },
                              indicator: const FxTabIndicator(
                                  indicatorColor: CustomTheme.primary,
                                  indicatorHeight: 3,
                                  radius: 4,
                                  width: 60,
                                  indicatorStyle: FxTabIndicatorStyle.rectangle,
                                  yOffset: -7),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: CustomTheme.primary,
                              tabs: buildTab(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
