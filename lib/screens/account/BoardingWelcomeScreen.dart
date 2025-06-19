import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/screens/account/RegisterScreen.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:nudipu/utils/AppConfig.dart';

import '../../controllers/MainController.dart';
import '../full_app/full_app.dart';

class BoardingWelcomeScreen extends StatefulWidget {
  static const String tag = "BoardingWelcomeScreen";

  const BoardingWelcomeScreen({Key? key}) : super(key: key);

  @override
  _BoardingWelcomeScreenState createState() => _BoardingWelcomeScreenState();
}

class _BoardingWelcomeScreenState extends State<BoardingWelcomeScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final MainController mainController = Get.put(MainController());
  late Future<void> futureInit;

  @override
  void initState() {
    super.initState();
    futureInit = myInit();
  }

  Future<void> myInit() async {
    try {
      // Load the logged-in user if available
      await mainController.getLoggedInUser();
    } catch (e) {
      // Handle login error gracefully
      debugPrint("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      body: FutureBuilder<void>(
        future: futureInit,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return loader();
            default:
            // If user is already logged in, go to FullApp
              if (mainController.userModel.id > 0) {
                // Push-replacement to avoid popping errors
                Future.microtask(
                        () => Navigator.pushReplacementNamed(context, FullApp.tag));
                // Return an empty widget so we don't build the welcome screen beneath
                return const SizedBox();
              }
              // Otherwise show the normal welcome content
              return mainContent();
          }
        },
      ),
    );
  }

  Widget loader() {
    return SafeArea(
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/images/welcome.png'),
            fit: BoxFit.cover,
            width: 200,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: Get.width / 10),
              color: CustomTheme.primary,
              child: const Image(
                width: 200, // You may prefer Get.width / 2 if you like
                image: AssetImage('assets/images/logo-2.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainContent() {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          Image(
            image: const AssetImage('assets/images/logo.png'),
            width: Get.width / 2,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          Container(
            color: CustomTheme.primary,
            child: Column(
              children: [
                const SizedBox(height: 30),
                FxText.headlineMedium(
                  "Welcome to ${AppConfig.app_name}!",
                  fontWeight: 700,
                  color: Colors.white,
                ),
                FxText.bodyLarge(
                  "your favorite shopping destination.",
                  fontWeight: 500,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 30),
                FxButton.rounded(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 15, left: 20, right: 20),
                  borderRadiusAll: 100,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, FullApp.tag);
                  },
                  backgroundColor: Colors.white,
                  child: FxText.headlineSmall(
                    'Continue >',
                    fontWeight: 800,
                    color: CustomTheme.primary1,
                  ),
                ),
                const SizedBox(height: 30),
                Divider(
                  height: 0,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      FxText.bodyLarge(
                        'Don\'t have account?',
                        color: Colors.grey.shade300,
                      ),
                      FxButton.text(
                        padding: const EdgeInsets.only(left: 2),
                        onPressed: () {
                          Get.to(() => const RegisterScreen());
                        },
                        child: FxText.bodyLarge(
                          'Create Account',
                          fontWeight: 800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
