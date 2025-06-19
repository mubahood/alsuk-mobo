import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dioPackage;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:nudipu/models/SessionLocal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/LoggedInUserModel.dart';
import '../models/VendorModel.dart';
import '../theme/app_theme.dart';
import 'AppConfig.dart';

class Utils {
  static String shotten(String data, int limit) {
    if (data.length > limit) {
      return "${data.substring(0, limit - 2)}...";
    }
    return data;
  }

/*
  static Future<void> initOneSignal(LoggedInUserModel u) async {
    print("=====INITING ONE SIGNAL=====");
    //await Firebase.initializeApp();
    // Set the background messaging handler early on, as a named top-level function
    OneSignal.shared.setAppId(AppConfig.ONESIGNAL_APP_ID);

    if (u.id > 0) {
      OneSignal.shared.setExternalUserId(u.id.toString());
      print("=====ONE SIGNAL USER ID: ${u.id} =====");
    }
  
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("=====ONE SIGNAL PERMISSION: $accepted =====");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print("=====ONE SIGNAL event ID: ${event.notification.title} =====");
      print("=====ONE SIGNAL event ID: ${event.notification.subtitle} =====");
      print("=====ONE SIGNAL event ID: ${event.notification.category} =====");
      print("=====ONE SIGNAL event ID: ${event.notification.body} =====");
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {

      if (result.notification.additionalData != null) {
        Map<String, dynamic>? data = result.notification.additionalData;
        if (data != null) {
          if (data["receiver_id"] != null) {
            if (data["chat_head_id"] != null) {
              MainController mainController = MainController();
              await mainController.getLoggedInUser();
              Get.put(mainController);
              int chatHeadId = Utils.int_parse(data["chat_head_id"]);
              Utils.toast2(chatHeadId.toString());
              if (chatHeadId > 0) {
                LoggedInUserModel u =
                await LoggedInUserModel.getLoggedInUser();
                ChatHead chatHead = ChatHead();
                List<ChatHead> chatHeads = await ChatHead.get_items(u,
                    where: "id = $chatHeadId");
                if (chatHeads.isEmpty) {
                  await ChatHead.getOnlineItems();
                  chatHeads = await ChatHead.get_items(u,
                      where: "id = $chatHeadId");
                }
                if (chatHeads.isNotEmpty) {
                  chatHead = chatHeads[0];
                }
                if (chatHead.id > 0) {
                  Get.to(() => ChatScreen(
                    chatHead,
                    Product(),
                  ));
                } else {
                  Get.to(() => const ChatsScreen());
                }
              }
            }
          }
        }
      }
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
      print("=====ONE SIGNAL SUCCESS REGISTRED ID: ${changes.to.userId} =====");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges emailChanges) {
          // Will be called whenever then user's email subscription changes
          // (ie. OneSignal.setEmail(email) is called and the user gets registered
        });
  }
*/

  static Future<void> systemBoot() async {
    await VendorModel.getOnlineItems();
  }

  static String prepare_phone_number(String phoneNumber) {
    return phoneNumber;
    if (phoneNumber.length > 12) {
      phoneNumber = phoneNumber.replaceFirst('+', "");
      phoneNumber = phoneNumber.replaceFirst('256', "");
    } else {
      phoneNumber = phoneNumber.replaceFirst('0', "");
    }
    if (phoneNumber.length != 9) {
      return "";
    }
    phoneNumber = "+256$phoneNumber";
    return phoneNumber;
  }

  static bool phone_number_is_valid(String phoneNumber) {
    return true;
    phoneNumber = Utils.prepare_phone_number(phoneNumber);
    if (phoneNumber.length != 13) {
      return false;
    }

    if (phoneNumber.substring(0, 4) != "+256") {
      return false;
    }

    return true;
  }

  static bool contains(List<dynamic> items, dynamic item) {
    bool yes = false;
    for (var e in items) {
      if (e.id == item.id) {
        yes = true;
        break;
      }
    }
    return yes;
  }

  static Future<void> set_local(String key, String data) async {
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    prefs.setString(key, data);
    return;
  }

  static Future<dynamic> http_post(
      String path, Map<String, dynamic> body) async {
    bool isOnline = await Utils.is_connected();
    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }
    dynamic response;
    var dio = Dio();

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    try {
      LoggedInUserModel userModel = await LoggedInUserModel.getLoggedInUser();
      String token = await getToken();
      body['user'] = userModel.id.toString();
      body['User-Id'] = userModel.id.toString();
      body['user_id'] = userModel.id.toString();
      var da = dioPackage.FormData.fromMap(body); //.fromMap();
      print("=======================");
      print("${AppConfig.API_BASE_URL}/$path");
      response = await dio.post("${AppConfig.API_BASE_URL}/$path",
          data: da,
          options: Options(
            headers: <String, String>{
              "Authorization": 'Bearer $token',
              "Content-Type": "application/json",
              "Accept": "application/json",
              "User-Id": "${userModel.id}",
            },
          ));

      print("SUCCESS");
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print("========post FAILED CONNECTION===");
      print(e.error);
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }

        print(e.response?.data);
      }
      Map<String, dynamic> map = {
        'status': 0,
        'message': "Failed because ${e.message.toString()}"
      };
      return jsonEncode(map);
    }
  }

  static Future<bool> is_logged_in() async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    if (u.id < 1) {
      return false;
    } else {
      //// await LoggedInUserModel.update_local_user();
      return true;
    }
  }

  static String get_file_url(String name) {
    String url = "${AppConfig.MAIN_SITE_URL}/storage/uploads";
    if ((name.length < 2)) {
      url += '/default.png';
    } else {
      url += '/$name';
    }
    return url;
  }

  static Future<String> getToken() async {
    String token = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
    return token;
  }

  static Future<dynamic> http_get(
      String path, Map<String, dynamic> body) async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    String token = await getToken();

    bool isOnline = await Utils.is_connected();
    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }

    dioPackage.Response response;
    var dio = Dio();

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    try {
      body['user'] = u.id.toString();
      body['User-Id'] = u.id.toString();
      body['user_id'] = u.id.toString();
      /*     print("=============START FECHING DATA================");
      print("${AppConfig.API_BASE_URL}/$path");*/
      response = await dio.get("${AppConfig.API_BASE_URL}/$path",
          queryParameters: body,
          options: Options(headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": 'Bearer $token',
            "User-Id": '${u.id}',
          }));
/*      print("=============FINISHED DATA================");
      print(response.data);
      print("==================DONE================");*/
      return response.data;
    } on DioError catch (e) {
      print("======FAILED CONNECTION===");
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      return {
        'status': 0,
        'code': 0,
        'message': e.response?.data,
        'data': null,
      };
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await LoggedInUserModel.deleteAll();
    await deleteDatabase(AppConfig.DATABASE_PATH);
    Navigator.popAndPushNamed(Get.context!, "/OnBoardingScreen");
    return;
  }

  static void launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  static Future<Database> getDb() async {
    return await dbInit();
  }

  static Future<Database> dbInit() async {
    return await openDatabase(AppConfig.DATABASE_PATH, version: 4);
  }

  static Future<void> boot_system() async {
    SessionLocal.uploadPending();
  }

  static void init_theme() {
    AppTheme.resetFont();

    SystemChrome.setSystemUIOverlayStyle(
      Utils.overlay(),
    );
  }

  static Future<dynamic> init_databse() async {}

  static void launchPhone(String phoneNumber) async {
    if (!await launch('tel:$phoneNumber')) {
      throw 'Could not launch $phoneNumber';
    }
  }

  static String yes_no_parse(dynamic x) {
    if (x == null) {
      return 'No';
    }
    if (Utils.int_parse(x) == 1) {
      return 'Yes';
    } else {
      return 'No';
    }
  }

  static String to_str(dynamic x, String y) {
    if (x == null) {
      return y;
    }
    if (x.toString().toString() == 'null') {
      return y;
    }
    if (x.toString().isEmpty) {
      return y.toString();
    }
    return x.toString();
  }

  static double double_parse(dynamic x) {
    if (x == null) {
      return 0.0;
    }
    double temp = 0.0;
    try {
      temp = double.parse(x.toString());
    } catch (e) {
      temp = 0.0;
    }

    return temp;
  }

  static int int_parse(dynamic x) {
    if (x == null) {
      return 0;
    }
    //remove decimal
    x = x.toString().replaceAll(RegExp(r'\.\d+'), '');
    int temp = 0;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    return temp;
  }

  static bool bool_parse(dynamic x) {
    int temp = 0;
    bool ans = false;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    if (temp == 1) {
      ans = true;
    } else {
      ans = false;
    }
    return ans;
  }

  static double screen_width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screen_height(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<bool> is_connected() async {
    return await InternetConnectionChecker().hasConnection;
    // bool is_connected = false;
    // var connectivityResult = await (Connectivity().checkConnectivity());
    //
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   // I am connected to a mobile network.
    //   is_connected = true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   // I am connected to a wifi network.
    //   is_connected = true;
    // }
    //
    // return is_connected;
  }

  static log(String message) {
    debugPrint(message, wrapWidth: 12000);
  }

  static bool isValidMail(String mail) {
    if (mail.isEmpty) {
      return false;
    }
    if (mail.length < 3) {
      return false;
    }
    if (!mail.contains('@')) {
      return false;
    }
    if (!mail.contains('.')) {
      return false;
    }
    return true;
  }

  static toast(String message,
      {Color color = Colors.green, bool isLong = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }
    toast2(message,
        background_color: color, color: Colors.white, is_long: isLong);
    return;

    Get.snackbar('Alert', message,
        dismissDirection: DismissDirection.down,
        colorText: Colors.white,
        backgroundColor: color,
        margin: EdgeInsets.zero,
        duration:
            isLong ? const Duration(seconds: 2) : const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED);
  }

  static String convertToJsonStringQuotes({required String raw}) {
    String jsonString = raw;

    /// add quotes to json string
    jsonString = jsonString.replaceAll('{', '{"');
    jsonString = jsonString.replaceAll(': ', '": "');
    jsonString = jsonString.replaceAll(', ', '", "');
    jsonString = jsonString.replaceAll('}', '"}');

    /// remove quotes on object json string
    jsonString = jsonString.replaceAll('"{"', '{"');
    jsonString = jsonString.replaceAll('"}"', '"}');

    /// remove quotes on array json string
    jsonString = jsonString.replaceAll('"[{', '[{');
    jsonString = jsonString.replaceAll('}]"', '}]');

    return jsonString;
  }

  static void toast2(String message,
      {Color background_color = CustomTheme.primary,
      color = Colors.white,
      bool is_long = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }

    Fluttertoast.showToast(
        msg: message,
        toastLength: is_long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: background_color,
        textColor: color,
        fontSize: 16.0);
  }

  static void go_to_home(context) {
    Navigator.pushNamedAndRemoveUntil(context, "/HomeScreen", (r) => false);
  }

  static Future<void> showConfirmDialog(
    BuildContext context,
    Function onPositiveClick,
    Function onNegativeClick, {
    String message = "Please confirm this action",
    String positive_text = "Confirm",
    String negative_text = "Cancel",
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: FxSpacing.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.bodyLarge(
                      "$message\n",
                      fontWeight: 500,
                    ),
                    Container(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          children: [
                            FxButton.block(
                                onPressed: () {
                                  onPositiveClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.bodyLarge(positive_text,
                                    letterSpacing: 0.3, color: Colors.white)),
                            const SizedBox(
                              height: 10,
                            ),
                            FxButton.outlined(
                                onPressed: () {
                                  onNegativeClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.bodyLarge(negative_text,
                                    letterSpacing: 0.3, color: Colors.red)),
                          ],
                        )),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  static SystemUiOverlayStyle overlay() {
    // Set the status bar color and icon brightness programmatically
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      // Set your desired color
      statusBarIconBrightness: Brightness.light,
      // Set icon brightness
      statusBarBrightness: Brightness.dark,
      // For iOS
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: CustomTheme.primary,
      systemNavigationBarDividerColor: CustomTheme.primary,
      systemNavigationBarContrastEnforced: true,
    ));

    return const SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      // White icons
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: CustomTheme.primary,
      systemNavigationBarDividerColor: CustomTheme.primary,
      statusBarBrightness: Brightness.dark,
      // Ensures white icons on iOS
      systemNavigationBarContrastEnforced: true, // Ensures contrast on Android
    );
  }

/*  static Future<Position> get_device_location() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }*/

  void upload_image(String path) async {}

  static double mediaWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isDesktop(BuildContext context) {
    return false;
    if (MediaQuery.of(context).size.width > 700) {
      return true;
    }
    return false;
  }

  static double mediaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double sizeByWidth(BuildContext context, double w) {
    return MediaQuery.of(context).size.width / w;
  }

  static double fs1(BuildContext context) {
    return Utils.sizeByWidth(context, 5);
  }

  static double fs2(BuildContext context) {
    return Utils.sizeByWidth(context, 6);
  }

  static double fs3(BuildContext context) {
    return Utils.sizeByWidth(context, 6.5);
  }

  static double fs4(BuildContext context) {
    return Utils.sizeByWidth(context, 7);
  }

  static double fs5(BuildContext context) {
    return Utils.sizeByWidth(context, 7.5);
  }

  static double fs6(BuildContext context) {
    return Utils.sizeByWidth(context, 8);
  }

  static double fs7(BuildContext context) {
    return Utils.sizeByWidth(context, 8.5);
  }

  static double fs8(BuildContext context) {
    return Utils.sizeByWidth(context, 9);
  }

  static double fs9(BuildContext context) {
    return Utils.sizeByWidth(context, 9.5);
  }

  static double fs10(BuildContext context) {
    return Utils.sizeByWidth(context, 10);
  }

  static double fs11(BuildContext context) {
    return Utils.sizeByWidth(context, 10.6);
  }

  static double fs12(BuildContext context) {
    return Utils.sizeByWidth(context, 11);
  }

  static double fs13(BuildContext context) {
    return Utils.sizeByWidth(context, 11.5);
  }

  static double fs14(BuildContext context) {
    return Utils.sizeByWidth(context, 12);
  }

  static double fs15(BuildContext context) {
    return Utils.sizeByWidth(context, 15);
  }

  static double fs16(BuildContext context) {
    return Utils.sizeByWidth(context, 16);
  }

  static double fs17(BuildContext context) {
    return Utils.sizeByWidth(context, 17);
  }

  static double fs18(BuildContext context) {
    return Utils.sizeByWidth(context, 18);
  }

  static double fs19(BuildContext context) {
    return Utils.sizeByWidth(context, 19);
  }

  static double fs20(BuildContext context) {
    return Utils.sizeByWidth(context, 20);
  }

  static String to_date(dynamic updatedAt) {
    String dateText = "--:--";
    if (updatedAt == null) {
      return "--:--";
    }
    if (updatedAt.toString().length < 5) {
      return "--:--";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y - ").format(date);
      dateText += DateFormat("jm").format(date);
    } catch (e) {}

    return dateText;
  }

  static String getUniqueText() {
    String text = '';
    text = DateTime.now().millisecondsSinceEpoch.toString();
    //add random number
    text += Random().nextInt(1000000).toString();
    text += Random().nextInt(1000000).toString();
    text += Random().nextInt(1000000).toString();
    text += Random().nextInt(1000000).toString();
    text += Random().nextInt(1000000).toString();
    text += Random().nextInt(1000000).toString();
    return text;
  }

  static String img(dynamic img) {
    return getImageUrl(img);
  }

  static String getImageUrl(dynamic img) {
    String img0 = "logo.png";
    if (img != null) {
      img = img.toString();
      if (img.toString().isNotEmpty) {
        img0 = img;
      }
    }
    img0.replaceAll('/images', '');
    return "${AppConfig.MAIN_SITE_URL}/storage/$img0";
  }

  static String to_date_1(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y").format(date);
    } catch (e) {}

    return dateText;
  }

  static DateTime toDate(dynamic updatedAt) {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(updatedAt.toString());
    } catch (e) {
      date = DateTime.now();
    }

    return date;
  }

  static String money(String price) {
    return "${AppConfig.CURRENCY} " + moneyFormat(price);
  }

  static String moneyFormat(String price) {
    String section_1 = '';
    String section_2 = '';

    //check if price contains decimal
    if (price.contains('.')) {
      List<String> sections = price.split('.');
      if (sections.length == 1) {
        section_1 = sections[0];
        section_2 = '';
      }
      if (sections.length == 2) {
        section_1 = sections[0];
        section_2 = sections[1];
      }
    } else {
      section_1 = price;
      section_2 = '';
    }

    int value0 = Utils.int_parse(section_1);
    if (section_1.length > 2) {
      //remove decimal
      section_1 = section_1.replaceAll(RegExp(r'\.\d+'), '');
      section_1 = section_1.replaceAll(RegExp(r'\D'), '');
      section_1 = section_1.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      if (value0 < 0) {
        section_1 = "-$section_1";
      }
    }
    if (section_2.isEmpty) {
      section_2 = "";
    }
    if (section_2.length == 1) {
      section_2 = "${section_2}";
    }
    return "${section_1}";
  }

  static Future<void> launchBrowser(String path) async {
    Uri uri = Uri.parse(path);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Utils.toast('Could not launch ${uri.toString()}', color: CustomTheme.red);
    }
  }

  static Future<void> downloadPhoto(String pic) async {
    List<String> downloadedPics = await getDownloadPics();
    if (downloadedPics.contains(pic)) {
      print("ALREADY DOWNLOADED PIC===> $pic");
      return;
    }

    Directory dir = await getApplicationDocumentsDirectory();

    Dio dio = Dio();
    String dirPath = dir.path;

    String url = '';
    if (pic.contains('images')) {
      url = "${AppConfig.MAIN_SITE_URL}/storage/$pic";
    } else {
      url = "${AppConfig.MAIN_SITE_URL}/storage/images/$pic";
    }

    String fileName = pic.split('/').last;

    var response = await dio.download(url, '$dirPath/$fileName');
    if (response.statusCode == 200) {
      print(" SUCCESS DOWNLOAD ===> $pic");
    } else {
      print("FAILED DOWNLOAD ===> $pic ==> BECAUSE ${response.statusCode}");
    }
  }

  static Future<List<String>> getDownloadPics() async {
    List<String> downloadedPics = [];

    Directory dir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = dir.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        downloadedPics.add(file.path.split('/').last);
      }
    }
    return downloadedPics;
  }

  static void setStatusStyle(dark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: dark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness:
          dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: CustomTheme.primary,
    ));
  }

  static Color getColor(String col) {
    col = col.toLowerCase();
    Color color = Colors.white;
    if (col.isEmpty) {
      return color;
    } else if (col == "white") {
      return Colors.white;
    } else if (col == "black") {
      return Colors.black;
    } else if (col == "red") {
      return Colors.red;
    } else if (col == "green") {
      return Colors.green;
    } else if (col == "blue") {
      return Colors.blue;
    } else if (col == "yellow") {
      return Colors.yellow;
    } else if (col == "orange") {
      return Colors.orange;
    } else if (col == "pink") {
      return Colors.pink;
    } else if (col == "purple") {
      return Colors.purple;
    } else if (col == "brown") {
      return Colors.brown;
    } else if (col == "grey") {
      return Colors.grey;
    } else if (col == "maroon") {
      return Color(0xFF800000);
    } else if (col == "gold") {
      return Color(0xFFD4AF37);
    } else if (col == "silver") {
      return Color(0xFFC0C0C0);
    } else if (col == "darkblue") {
      return Color(0xFF00008B);
    } else if (col == "bronze") {
      return Color(0xFFCD7F32);
    } else {
      return Colors.white;
    }
    /*
    *     'Black',
    'Blue',
    'Brown',
    'Green',
    'Grey',
    'Orange',
    'Pink',
    'Purple',
    'Red',
    'White',
    'Yellow',
    'Maroon',
    'Gold',
    'Silver',
    'Bronze',
    'Other',*/
    return color;
  }
}
