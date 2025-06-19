import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:nudipu/theme/app_theme.dart';

import '../../models/Job.dart';
import '../../sections/widgets.dart';
import '../../utils/Utils.dart';

class JobScreen extends StatefulWidget {
  Job item;

  JobScreen(this.item, {Key? key}) : super(key: key);

  @override
  _JobScreenState createState() => _JobScreenState(item);
}

class _JobScreenState extends State<JobScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  Job item;

  _JobScreenState(this.item);

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
          "Job  details",
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
                      item.title,
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
                                  'JOB NATURE',
                                  color :Colors.black,
                                  fontWeight : 800,
                                ),
                                const SizedBox(height: 5),
                                FxContainer(
                                  color :CustomTheme.primary,
                                  borderRadiusAll: 0,
                                  paddingAll: 5,
                                  child: FxText.bodySmall(
                                    item.nature_of_job.toUpperCase(),
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
                        roundedImage(item.photo.toString(), 3, 3),
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
                    singleWidget(
                        'ACADEMICS', item.minimum_academic_qualification),
                    singleWidget('expirience', item.required_expirience),
                    singleWidget(
                        'expirience PERIOD', "${item.expirience_period} Years"),
                    singleWidget('POSTED', Utils.to_date_1(item.created_at)),
                    singleWidget('AVAILABLE SLOTS', item.slots),
                    singleWidget('deadline', Utils.to_date_1(item.deadline)),
                    singleWidget('CONTACT', item.whatsapp),
                    singleWidget('JOB DETAILS', item.details),
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
              padding:
                  const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
              child: FxButton.block(
                onPressed: () {
                  Utils.launchPhone(item.whatsapp);
                },
                borderRadiusAll: 100,
                child: FxText.titleLarge(
                  'CONTACT EMPLOYEE',
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
