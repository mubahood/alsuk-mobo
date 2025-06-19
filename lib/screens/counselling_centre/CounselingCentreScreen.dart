import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:nudipu/models/CounsellingCentre.dart';
import 'package:nudipu/theme/app_theme.dart';

import '../../sections/widgets.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';

class CounselingCentreScreen extends StatefulWidget {
  CounsellingCentre item;

  CounselingCentreScreen(this.item, {Key? key}) : super(key: key);

  @override
  _CounselingCentreScreenState createState() =>
      _CounselingCentreScreenState(item);
}

class _CounselingCentreScreenState extends State<CounselingCentreScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  CounsellingCentre item;

  _CounselingCentreScreenState(this.item);

  @override
  void initState() {
    super.initState();
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
          "Job details",
          color :Colors.white,
          maxLines: 2,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    FxText.titleLarge(
                      item.name,
                      color :Colors.black,
                      fontWeight : 800,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText(
                                  'SPECIALIZATION',
                                  color :Colors.black,
                                  fontWeight : 800,
                                ),
                                const SizedBox(height: 5),
                                FxContainer(
                                  color :CustomTheme.primary,
                                  borderRadiusAll: 0,
                                  paddingAll: 5,
                                  child: FxText.bodySmall(
                                    item.skills.toUpperCase(),
                                    color :Colors.white,
                                    fontWeight : 800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FxText(
                                  'LOCATION',
                                  color :Colors.black,
                                  fontWeight : 800,
                                ),
                                const SizedBox(height: 0),
                                FxText(
                                  item.subcounty_text,
                                  fontWeight : 800,
                                ),
                              ],
                            ),
                          ),
                        ),
                        roundedImage(
                            '${AppConfig.DASHBOARD_URL}/storage/${item.photo}'
                                .toString(),
                            3,
                            3),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color :CustomTheme.primary,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    singleWidget('parish', item.parish),
                    singleWidget('village', item.village),
                    singleWidget('email', item.email),
                    singleWidget('Phone number', item.phone_number),
                    singleWidget('Website', item.website),
                    singleWidget('FEES RANGE', item.fees_range),
                    singleWidget('ABOUT', ''),
                    Html(
                      data: item.about,
                      /* style: {
                        "strong": Style(
                            color = CustomTheme.primary,
                            fontSize: FontSize(18),
                            fontWeight : FontWeight.normal),
                      },*/
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              color :CustomTheme.primary,
              height: 0,
            ),
            Container(
              color :CustomTheme.primary.withAlpha(20),
              padding: const EdgeInsets.only(
                  bottom: 10, right: 10, left: 10, top: 10),
              child: FxButton.block(
                onPressed: () {
                  Utils.launchPhone(item.phone_number);
                },
                borderRadiusAll: 100,
                child: FxText.titleLarge(
                  'CONTACT counselor'.toUpperCase(),
                  color :Colors.white,
                  fontWeight : 900,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
