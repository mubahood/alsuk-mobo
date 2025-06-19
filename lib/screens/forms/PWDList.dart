import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/Person.dart';
import 'package:nudipu/theme/app_theme.dart';

import '../../sections/widgets.dart';
import 'PWDFormCreateScreen.dart';

class PWDList extends StatefulWidget {
  const PWDList({Key? key}) : super(key: key);

  @override
  _PWDListState createState() => _PWDListState();
}

class _PWDListState extends State<PWDList> with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

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
          "My persons with disabilities",
          color :Colors.white,
          maxLines: 2,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
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
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      FxButton(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        borderRadiusAll: 100,
                        onPressed: () {
                          Get.to(() => const PWDFormCreateScreen());
                        },
                        child: FxText.titleMedium(
                          'PRESS THIS BUTTON TO REGISTER NEW PERSON WITH DISABILITY',
                          color :Colors.white,
                          textAlign: TextAlign.center,
                          fontWeight : 800,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FxText.bodyLarge(
                        "There are ${items.length} items in this list.",
                        height: 1,
                        fontWeight : 800,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Person m = items[index];
                  print(m.photo);
                  return personWidget(m);
                },
                childCount: items.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<Person> items = [];

  Future<dynamic> myInit() async {
    items = await Person.getItems();
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
                    color :Colors.black,
                    fontWeight : 900,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight : 600,
                    color :Colors.grey.shade700,
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
