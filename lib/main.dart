import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nudipu/screens/OnBoardingScreen.dart';
import 'package:nudipu/screens/account/BoardingWelcomeScreen.dart';
import 'package:nudipu/screens/full_app/full_app.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:nudipu/utils/Utils.dart';

void main() {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  Utils.boot_system();
  Utils.init_databse();
  Utils.init_theme();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme.init();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: EasyLoading.init(),
      home: const OnBoardingScreen(),
      routes: {
        '/OnBoardingScreen': (context) => const OnBoardingScreen(),
        FullApp.tag: (context) => const FullApp(),
        BoardingWelcomeScreen.tag: (context) => const BoardingWelcomeScreen(),
      },
    );
  }
}

class GlobalMaterialLocalizations {}
