import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/Product.dart';
import 'package:nudipu/models/VendorModel.dart';
import 'package:nudipu/screens/shop/ProductScreen.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

import '../sections/widgets.dart';
import 'AppConfig.dart';
import 'Utils.dart';

Widget ProductItemUi(Product pro) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: FxContainer(
      borderColor: CustomTheme.primaryDark,
      bordered: false,
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10),
      paddingAll: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: Get.width / 2,
              imageUrl:
                  "${AppConfig.MAIN_SITE_URL}/storage/${pro.feature_photo}",
              placeholder: (context, url) {
                return ShimmerLoadingWidget(
                  height: Get.width / 2,
                );
              },
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AppConfig.NO_IMAGE),
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              Get.to(() => ProductScreen(pro));
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FxText.titleSmall(
                    "${pro.name} ",
                    height: .9,
                    fontWeight: 800,
                    maxLines: 1,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: FxText.bodyMedium(
                          "${AppConfig.CURRENCY}${Utils.moneyFormat(pro.price_1)}",
                          color: CustomTheme.primaryDark,
                          fontWeight: 800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget VendorUi(VendorModel item) {
  double h = Get.height / 6;
  return Stack(
    children: [
      Container(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.infinity,
            height: h,
            imageUrl:
                "https://images.unsplash.com/photo-1525562723836-dca67a71d5f1?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            placeholder: (context, url) =>
                ShimmerLoadingWidget(height: Get.width / 4),
            errorWidget: (context, url, error) => Image(
              image: const AssetImage(
                AppConfig.NO_IMAGE,
              ),
              fit: BoxFit.cover,
              width: Get.width / 4,
              height: Get.width / 4,
            ),
          ),
        ),
      ),
      FxContainer(
        marginAll: 10,
        height: h,
        borderRadiusAll: 15,
        width: double.infinity,
        color: Colors.black.withOpacity(.6),
      ),
      Container(
        margin: const EdgeInsets.only(
          top: 30,
          left: 25,
          right: 25,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10000),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: Get.width / 4.5,
                height: Get.width / 4.5,
                imageUrl:
                    "${AppConfig.MAIN_SITE_URL}/storage/${item.business_logo}",
                placeholder: (context, url) =>
                    ShimmerLoadingWidget(height: Get.width / 4),
                errorWidget: (context, url, error) => Image(
                  image: const AssetImage(
                    AppConfig.NO_IMAGE,
                  ),
                  fit: BoxFit.cover,
                  width: Get.width / 4,
                  height: Get.width / 4,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleLarge(
                      item.business_name,
                      color: Colors.white,
                      fontWeight: 800,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FxText.bodySmall(
                      item.address,
                      color: Colors.white,
                      fontWeight: 800,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FxText.bodySmall(
                      item.business_whatsapp,
                      color: Colors.white,
                      fontWeight: 800,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget ProductUi(Product pro) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: FxContainer(
      color: Colors.grey.shade200,
      borderColor: CustomTheme.primaryDark,
      padding: const EdgeInsets.only(bottom: 15),
      borderRadiusAll: 10,
      paddingAll: 0,
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              width: double.infinity,
              imageUrl:
                  "${AppConfig.MAIN_SITE_URL}/storage/${pro.feature_photo}",
              placeholder: (context, url) => ShimmerLoadingWidget(),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AppConfig.NO_IMAGE),
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              Get.to(() => ProductScreen(pro));
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FxText.titleSmall(
                    "${pro.name} ",
                    height: .9,
                    fontWeight: 800,
                    maxLines: 1,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: FxText.bodyMedium(
                          "${AppConfig.CURRENCY}${Utils.moneyFormat(pro.price_1)}",
                          color: CustomTheme.primaryDark,
                          fontWeight: 800,
                        ),
                      ),
                      FxCard(
                        marginAll: 0,
                        color: CustomTheme.primary,
                        onTap: () {
                          Utils.toast("Product added to cart.");
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        child: FxText.bodySmall(
                          'BUY NOW',
                          fontWeight: 800,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget MyDivider(String title) {
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Expanded(
              child: Container(
            color: CustomTheme.primary,
            height: 15,
          )),
          const SizedBox(
            width: 10,
          ),
          Container(
            child: FxText.titleMedium(
              title.toUpperCase(),
              fontWeight: 900,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            color: CustomTheme.primary,
            height: 15,
          )),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

Widget valueUnitWidget2(dynamic title, dynamic value,
    {double fontSize = 6,
    double letterSpacing = -1,
    Color titleColor = Colors.grey,
    Color color = Colors.black,
    fontWeight = FontWeight.w500}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          '${title.toString().toUpperCase()}:',
          height: 0,
          color: titleColor,
        ),
        FxText.bodyLarge(
          value.toString(),
          height: 0,
          color: color,
          letterSpacing: -.5,
        ),
      ],
    ),
  );
}

Widget valueUnitWidget(BuildContext context, dynamic value, dynamic unit,
    {double fontSize = 6,
    double letterSpacing = -1,
    Color color = Colors.grey,
    Color titleColor = Colors.black,
    fontWeight = FontWeight.w500}) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(
        height: 1,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: value.toString(),
          style: TextStyle(
              color: titleColor,
              letterSpacing: letterSpacing,
              fontSize: Utils.mediaWidth(context) / fontSize,
              fontWeight: fontWeight),
        ),
        TextSpan(
          text: ' ${unit.toString()}',
          style: TextStyle(
            color: color,
            fontSize: Utils.mediaWidth(context) / (fontSize * 1),
          ),
        ),
      ],
    ),
    textScaler: const TextScaler.linear(0.5),
  );
}

Widget myListLoaderWidget(BuildContext context) {
  return ListView(
    children: [
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
    ],
  );
}

Widget myContainerLoaderWidget(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade50,
    highlightColor: Colors.grey.shade300,
    child: FxContainer(
      width: Utils.mediaWidth(context) / 4,
      height: Utils.mediaWidth(context) / 4,
      color: Colors.grey,
    ),
  );
}

Widget singleLoadingWidget(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 15,
      right: 10,
      top: 8,
      bottom: 8,
    ),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade300,
          child: FxContainer(
            width: Utils.mediaWidth(context) / 4,
            height: Utils.mediaWidth(context) / 4,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Shimmer.fromColors(
          baseColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxContainer(
                color: Colors.grey,
                height: Utils.mediaWidth(context) / 30,
                width: Utils.mediaWidth(context) / 3,
              ),
              const SizedBox(
                height: 5,
              ),
              FxContainer(
                height: Utils.mediaWidth(context) / 14,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
              FxContainer(
                height: Utils.mediaWidth(context) / 14,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  FxContainer(
                    color: Colors.grey,
                    height: Utils.mediaWidth(context) / 30,
                    width: Utils.mediaWidth(context) / 6,
                  ),
                  const Spacer(),
                  FxContainer(
                    color: Colors.grey,
                    height: Utils.mediaWidth(context) / 30,
                    width: Utils.mediaWidth(context) / 6,
                  ),
                ],
              )
            ],
          ),
        ))
      ],
    ),
  );
}
