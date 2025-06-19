import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/MyClasses.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import 'ClassScreen.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  ClassesScreenState createState() => ClassesScreenState();
}

class ClassesScreenState extends State<ClassesScreen> {
  List<MyClasses> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  Future<dynamic> doRefresh() async {
    futureInit = init();
    setState(() {});
  }

  late Future<dynamic> futureInit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            'My Classes (${items.length})',
            color :Colors.white,
            fontWeight : 700,
            height: .6,
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return Center(child: FxText('No item found.'));
            }

            return Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: doRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MyClasses myClass = items[index];
                          return FxContainer(
                            margin: const EdgeInsets.only(top: 5),
                            onTap: () {
                              Get.to(() => ClassScreen(data: myClass));
                            },
                            borderColor: CustomTheme.primaryDark,
                            bordered: true,
                            borderRadiusAll: 8,
                            color :CustomTheme.primary.withAlpha(40),
                            paddingAll: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  FeatherIcons.award,
                                  color :CustomTheme.primaryDark,
                                  size: 30,
                                ),
                                const Spacer(),
                                FxText.titleSmall(
                                  "${myClass.name} - ${myClass.short_name}",
                                  height: .8,
                                  color :Colors.black,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FxText.bodySmall(
                                  myClass.class_teacher_name,
                                  height: .9,
                                  maxLines: 2,
                                  color :CustomTheme.primaryDark,
                                ),
                                const Spacer(),
                                FxText.bodySmall(
                                  "${myClass.students_count} Students",
                                  height: .8,
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> init() async {
    items = await MyClasses.getItems();
    setState(() {});
  }
}
