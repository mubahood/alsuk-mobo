import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:nudipu/utils/AppConfig.dart';
import 'package:nudipu/utils/Utils.dart';

import '../data/my_colors.dart';
import '../utils/my_text.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      appBar: AppBar(
          backgroundColor: MyColors.primary,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: MyColors.primary),
          title: const Text("About", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.verified, color: Colors.white),
              onPressed: () {},
            )
          ]),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${AppConfig.app_name} App",
                  style: MyText.display1(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300)),
              Container(height: 5),
              Container(width: 120, height: 3, color: Colors.white),
              Container(height: 15),
              Text("Version",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("2.1.0",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 15),
              Text("Last Update",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("December 2023",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 25),
              Text(
                  'Afriinventions, your go-to e-commerce mobile application, seamlessly merges convenience with an extensive array of products, promising an unparalleled shopping experience. '
                  '\n\nWith a user-friendly interface, Hambren provides a one-stop destination for all your needs, offering a diverse selection of high-quality goods at your fingertips. '
                  '\n\nFrom trendy fashion to cutting-edge electronics, users can effortlessly browse, select, and securely purchase items, all while enjoying exclusive deals and promotions.'
                  '\n\nHambren prioritizes customer satisfaction, ensuring swift deliveries and reliable customer support. Elevate your online shopping journey with Hambren, where innovation meets accessibility for a delightful and efficient retail experience.',
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 25),
              FxButton.outlined(
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                borderRadius: BorderRadius.circular(4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onPressed: () {
                  Utils.launchBrowser(AppConfig.terms);
                },
                child: Text("Term of services",
                    style:
                        MyText.body1(context)!.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
