import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:nudipu/theme/app_theme.dart';

import '../../models/EventModel.dart';
import '../../sections/widgets.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';

class EventModelScreen extends StatefulWidget {
  EventModel item;

  EventModelScreen(this.item, {Key? key}) : super(key: key);

  @override
  _EventModelScreenState createState() => _EventModelScreenState(item);
}

class _EventModelScreenState extends State<EventModelScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  EventModel item;

  _EventModelScreenState(this.item);

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
          "Event details",
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
                    FxContainer(
                      color :CustomTheme.primary.withAlpha(60),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            '${AppConfig.DASHBOARD_URL}/storage/${item.photo}',
                        placeholder: (context, url) => ShimmerLoadingWidget(
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) => const Image(
                          image: AssetImage('no_image'),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                                FxContainer(
                                  color :CustomTheme.primary,
                                  borderRadiusAll: 0,
                                  paddingAll: 5,
                                  child: FxText.bodyLarge(
                                    "${item..event_date} ".toUpperCase(),
                                    color :Colors.white,
                                    fontWeight : 800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    singleWidget(
                        'EVENT DATE', Utils.to_date_1(item.event_date)),
                    Html(
                      data: item.details,
                      style: {
                        "strong": Style(
                            color :CustomTheme.primary,
                            fontSize: FontSize(18),
                            fontWeight : FontWeight.normal),
                      },
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
              padding:
                  const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
              child: FxButton.block(
                onPressed: () {
                  //Utils.launchPhone('+256701632257609');
                },
                borderRadiusAll: 100,
                child: FxText.titleLarge(
                  'CONTACT ORGANISERS',
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
