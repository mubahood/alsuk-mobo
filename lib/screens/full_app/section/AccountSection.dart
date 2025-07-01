import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/models/RespondModel.dart';
import 'package:nudipu/screens/account/AccountEdit.dart';
import 'package:nudipu/theme/app_theme.dart';
import 'package:nudipu/utils/Utils.dart';

import '../../../controllers/MainController.dart';
import '../../../models/AboutUsScreen.dart';
import '../../../sections/widgets.dart';
import '../../account/AccountChangePassword.dart';
import '../../account/account_vefication_screen.dart';
import '../../vendors/BecomeVendorFormScreen.dart';

class AccountSection extends StatefulWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  _AccountSectionState createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  late CustomTheme theme;

  @override
  void initState() {
    super.initState();
    theme = CustomTheme();
    myInit();
  }

  final MainController mainController = Get.find<MainController>();

  myInit() async {
    mainController.initialized;
    mainController.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        automaticallyImplyLeading: false,
        title: const Text(
          "Account",
        ),
      ),
      body: (mainController.userModel.id < 1)
          ? notLoggedInWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.user,
                      color: CustomTheme.primary,
                    ),
                    title: FxText.bodyLarge(
                      "My Profile",
                    ),
                    onTap: () {
                      Get.to(() => const AccountEdit());
                    },
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Change Password",
                    ),
                    onTap: () {
                      Get.to(() => const AccountChangePassword());
                    },
                    leading: const Icon(
                      FeatherIcons.key,
                      color: CustomTheme.primary,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Verify Account",
                    ),
                    onTap: () async {
                      await Get.to(() =>
                          AccountVerificationScreen(mainController.userModel));
                      await mainController.getLoggedInUser();
                      setState(() {});
                    },
                    leading: const Icon(
                      FeatherIcons.checkCircle,
                      color: CustomTheme.primary,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Change email address",
                    ),
                    onTap: () async {
                      await Get.to(() =>
                          AccountVerificationScreen(mainController.userModel));
                      await mainController.getLoggedInUser();
                      setState(() {});
                    },
                    leading: const Icon(
                      FeatherIcons.checkCircle,
                      color: CustomTheme.primary,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                  (!(mainController.userModel.isVendor()))
                      ? const SizedBox()
                      : ListTile(
                          title: FxText.bodyLarge(
                            "Edit Vendor Profile",
                          ),
                          leading: const Icon(
                            FeatherIcons.shoppingBag,
                            color: CustomTheme.primary,
                          ),
                          onTap: () {
                            Get.to(() => BecomeVendorFormScreen(
                                mainController.userModel));
                          },
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: CustomTheme.primary,
                          ),
                        ),
                  const Divider(),
                  ListTile(
                    title: FxText.bodyLarge(
                      "About Us",
                    ),
                    leading: const Icon(
                      FeatherIcons.info,
                      color: CustomTheme.primary,
                    ),
                    onTap: () {
                      Get.to(() => const AboutUsScreen());
                    },
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Contact Us",
                    ),
                    leading: const Icon(
                      FeatherIcons.phone,
                      color: CustomTheme.primary,
                    ),
                    onTap: () {
                      //show bottomsheet with phone call, whatsapp and email
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 210,
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FeatherIcons.phone,
                                      color: CustomTheme.primary,
                                    ),
                                    title: FxText.bodyLarge(
                                      "Call Us",
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Utils.launchPhone('+256780245409');
                                    },
                                    trailing: const Icon(
                                      FeatherIcons.chevronRight,
                                      color: CustomTheme.primary,
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FeatherIcons.phone,
                                      color: CustomTheme.primary,
                                    ),
                                    title: FxText.bodyLarge(
                                      "Whatsapp Us",
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Utils.launchBrowser(
                                          'https://wa.me/+256780245409?text=Hello%20Hambren%20Team\n\n');
                                    },
                                    trailing: const Icon(
                                      FeatherIcons.chevronRight,
                                      color: CustomTheme.primary,
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FeatherIcons.mail,
                                      color: CustomTheme.primary,
                                    ),
                                    title: FxText.bodyLarge(
                                      "Email Us",
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Utils.launchBrowser(
                                          'mailto:support@alsukssd.com?subject=Hello%Al%20Suk&body=Hello%AlSuk%20Team\n\n');
                                    },
                                    trailing: const Icon(
                                      FeatherIcons.chevronRight,
                                      color: CustomTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Delete Account",
                      color: Colors.red,
                    ),
                    leading: Icon(
                      FeatherIcons.trash2,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          middleText: "You want to delete your account?",
                          titleStyle: const TextStyle(color: Colors.red),
                          actions: <Widget>[
                            FxButton.outlined(
                              onPressed: () {
                                Navigator.pop(context);
                                do_delete();
                              },
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              borderColor: CustomTheme.primary,
                              child: FxText(
                                'DELETE',
                                color: CustomTheme.primary,
                              ),
                            ),
                            FxButton.small(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: FxText(
                                'CANCEL',
                                color: Colors.white,
                              ),
                            )
                          ]);
                    },
                    trailing: Icon(
                      FeatherIcons.chevronRight,
                      color: Colors.red,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Logout",
                    ),
                    leading: const Icon(
                      FeatherIcons.logOut,
                      color: CustomTheme.primary,
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          middleText: "Are you sure you want to logout?",
                          titleStyle: const TextStyle(color: Colors.black),
                          actions: <Widget>[
                            FxButton.outlined(
                              onPressed: () {
                                Navigator.pop(context);
                                do_logout();
                              },
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              borderColor: CustomTheme.primary,
                              child: FxText(
                                'LOGOUT',
                                color: CustomTheme.primary,
                              ),
                            ),
                            FxButton.small(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: FxText(
                                'CANCEL',
                                color: Colors.white,
                              ),
                            )
                          ]);
                    },
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> do_delete() async {
    Utils.toast("Deleting your account...");
    RespondModel res = RespondModel(await Utils.http_post('delete-account', {
      'id': mainController.userModel.id,
    }));
    if (res.code != 1) {
      Utils.toast(res.message);
      return;
    }
    Utils.toast(res.message);

    Utils.toast("Logging you out...");
    do_logout();
  }

  Future<void> do_logout() async {
    Utils.logout();
    Utils.toast("Logged you out!");
  }
}
