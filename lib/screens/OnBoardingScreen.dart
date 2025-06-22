import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/LoggedInUserModel.dart';
import '../controllers/MainController.dart';
import '../theme/app_theme.dart';
import '../utils/Utils.dart';
import 'account/BoardingWelcomeScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final MainController mainController = Get.put(MainController());
  late Future<void> futureInit;
  LoggedInUserModel loggedInUser = LoggedInUserModel();
  String img = '1';

  List<String> slogans = [
    'Buy and sell with ease on Al Suk.',
    'Discover great deals and offers at Al Suk.',
    'Al Suk: Your trusted marketplace for buying and selling.',
    'Find what you need or sell what you have on Al Suk.',
    'Experience secure transactions with Al Suk.',
    'Connect with buyers and sellers across Al Suk.',
    'Al Suk makes buying and selling simple.',
    'Start your buying and selling journey with Al Suk today.',
  ];

  @override
  void initState() {
    super.initState();
    // Randomize background image
    img = "${Random().nextInt(5) + 1}";
    AppTheme.init();
    futureInit = _initializeApp();
  }

  /// Load all necessary data; then decide where to navigate.
  Future<void> _initializeApp() async {
    try {
      // Optional artificial delay for a splash effect
      await Future.delayed(const Duration(seconds: 5));
      await mainController.getLoggedInUser();
      final String token = await LoggedInUserModel.get_token();
      // Another optional delay
      await Future.delayed(const Duration(seconds: 2));

      // If token is too short, assume not logged in
      if (token.length < 20) {
        Get.offAll(() => const BoardingWelcomeScreen());
        return;
      }

      // Check user info
      loggedInUser = await LoggedInUserModel.getLoggedInUser();
      if (loggedInUser.id < 1) {
        // No valid user => show welcome screen
        Get.offAll(() => const BoardingWelcomeScreen());
        return;
      }

      // Otherwise the user is logged in
      Utils.systemBoot();

      // Navigate to main area or any other screen (currently using welcome as placeholder)
      Get.offAll(() => const BoardingWelcomeScreen());
    } catch (e) {
      // If anything fails, go back to welcome
      debugPrint("Error during app initialization: $e");
      Get.offAll(() => const BoardingWelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: CustomTheme.primary),
    );

    String slogan = slogans[Random().nextInt(slogans.length)];

    return Scaffold(
      backgroundColor: CustomTheme.primary,
      body: FutureBuilder<void>(
        future: futureInit,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${img}.png'),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  // Slogan text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      slogan,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Gap between slogan and progress indicator (70 - 20 = 50)
                  const SizedBox(height: 50),
                  // Progress indicator at the bottom with padding
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        CustomTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
