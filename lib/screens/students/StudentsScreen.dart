import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../models/UserModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  StudentsScreenState createState() => StudentsScreenState();
}

class StudentsScreenState extends State<StudentsScreen> {
  List<UserModel> items = [];

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
            'Students (${items.length})',
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
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          UserModel m = items[index];
                          return userWidget(m);
                        },
                        childCount: items.length, // 1000 list items
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> init() async {
    items.sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }
}
