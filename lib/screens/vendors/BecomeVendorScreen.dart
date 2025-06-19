import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:nudipu/theme/custom_theme.dart';
import 'package:nudipu/utils/AppConfig.dart';

import '../../controllers/MainController.dart';
import '../../data/img.dart';
import '../../models/LoggedInUserModel.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import 'BecomeVendorFormScreen.dart';

class BecomeVendorScreen extends StatefulWidget {
  const BecomeVendorScreen({super.key});

  @override
  State<BecomeVendorScreen> createState() => _BecomeDriverState();
}

class _BecomeDriverState extends State<BecomeVendorScreen> {
  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Become a vendor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: CustomTheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 80,
                    child: Image.asset(Img.get('shop.png'), fit: BoxFit.cover),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Become a Vendor on ${AppConfig.app_name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: MyColors.grey_90,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: CustomTheme.primary,
                  indent: 16,
                  endIndent: 16,
                ),
                mainController.userModel.status == '2'
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'STATUS: Pending approval from admin. (${mainController.userModel.user_type})',
                          style: const TextStyle(
                              color: MyColors.grey_60,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Become a vendor on ${AppConfig.app_name} and start selling your products thousands of our customers across the country.',
                              style: const TextStyle(
                                  color: MyColors.grey_60,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            alignment: Alignment.center,
                            child: const Text(
                              'Requirements',
                              style: TextStyle(
                                color: CustomTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          titleTextWidget('Product Quality Standards:',
                              "We uphold stringent product quality standards to guarantee an exceptional and reliable shopping experience for our users. Vendors on our platform are required to meet these standards to ensure that the products offered meet or exceed customer expectations. This includes adherence to industry-specific quality benchmarks, accurate product descriptions, and high-resolution images that truthfully represent the item. We encourage vendors to provide transparent information about materials, sizing, and care instructions. Products that fail to meet these standards may be subject to removal from the platform. We prioritize customer satisfaction and trust, aiming to foster a marketplace where users can confidently explore and purchase high-quality fashion items."),
                          titleTextWidget('Legal Requirements:',
                              'Our platform operates in strict compliance with relevant local, national, and international laws and regulations governing e-commerce, data protection, and intellectual property. Users and vendors must adhere to all applicable laws when using our fashion app. This includes, but is not limited to, consumer protection laws, privacy regulations, and copyright laws. Vendors are responsible for ensuring that their products comply with safety and labeling standards. We reserve the right to take appropriate legal action in response to any activities or content that violate these laws or our terms of service. Additionally, users are encouraged to familiarize themselves with their rights and obligations to promote a lawful and secure environment for all participants on our platform.'),
                          titleTextWidget('Registration and Documentation:',
                              'To ensure the integrity and security of our fashion app, users and vendors are required to undergo a registration process that involves providing accurate and current information. During registration, users will be prompted to submit essential details, including contact information and, where applicable, business documentation. Vendors must provide necessary business registration documents, tax identification numbers, and comply with local licensing requirements. This documentation is crucial for verifying the legitimacy of vendors and maintaining a trustworthy marketplace. Users are responsible for keeping their information up-to-date, and any discrepancies may result in account suspension. We prioritize data security and strictly adhere to privacy policies to safeguard the confidentiality of the information provided during the registration process.'),
                          titleTextWidget('Product Authenticity:',
                              'Ensuring the authenticity of products is a cornerstone of our commitment to providing a reliable and trustworthy fashion platform. Vendors on our app are required to guarantee the authenticity of the products they list for sale. Any item represented as a brand-name or designer product must be genuine, and vendors should be able to provide documentation or certificates of authenticity upon request. We implement rigorous measures, including periodic audits and user feedback monitoring, to uphold the integrity of our marketplace. Any vendor found selling counterfeit or misrepresented products will face immediate account suspension, and appropriate legal action may be pursued. We encourage users to report any suspicions regarding product authenticity, fostering a community dedicated to genuine and high-quality fashion offerings.'),
                          titleTextWidget('Photography Guidelines:',
                              'To maintain a visually appealing and cohesive marketplace, we have established clear photography guidelines for vendors. Product images play a crucial role in the online shopping experience, and adherence to these guidelines ensures consistency and transparency. Vendors are required to use high-resolution images that accurately represent the product. Each listing should include multiple images showcasing different angles, details, and potential variations. Backgrounds should be clean and uncluttered, enhancing the visibility of the product. Images should not include watermarks, logos, or any promotional text that may distract from the product itself. Vendors are encouraged to showcase the product in use when applicable. These guidelines contribute to a visually pleasing and informative shopping environment, promoting customer confidence and satisfaction. Failure to comply with these standards may result in product delisting or other appropriate actions to maintain the overall quality of our platform.'),
                          titleTextWidget('Return and Refund Policy:',
                              'We understand that customer satisfaction is paramount, and we aim to provide a transparent and fair return and refund process. Customers may initiate a return within a specified timeframe, typically within [number of days] days of receiving the product. To be eligible for a return, items must be in their original condition, unworn, and with all tags intact. Vendors are responsible for clearly outlining product specifications and any potential limitations on returns in their listings. In the event of a return, customers may opt for a refund, exchange, or store credit, subject to the vendor\'s policies. Refunds will be processed within [number of days].'),
                          //compose for me some policy for vendors
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 15),
                            child: const Text(
                              'Benefits',
                              style: TextStyle(
                                color: CustomTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          titleTextWidget('Increased Sales:',
                              'By selling on your platform, vendors can reach a wider audience and increase their sales. This is especially true for small businesses that may not have the resources to market their products.'),
                          titleTextWidget('Brand Awareness:',
                              'Vendors can increase brand awareness by selling on your platform. This is particularly beneficial for new businesses that are trying to establish themselves in the market.'),
                          titleTextWidget('Customer Acquisition:',
                              'Vendors can acquire new customers by selling on your platform. This is especially true for small businesses that may not have the resources to market their products.'),
                          titleTextWidget('Customer Acquisition:',
                              'Vendors can acquire new customers by selling on your platform. This is especially true for small businesses that may not have the resources to market their products.'),
                          //compose requirements for vendors
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 20),
                            alignment: Alignment.center,
                            child: const Text(
                              'How to become a vendor',
                              style: TextStyle(
                                color: CustomTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          titleTextWidget('Step 1:',
                              'Click on the "Register as a vendor" button below.'),
                          titleTextWidget(
                              'Step 2:', 'Fill in the form and submit it.'),
                          titleTextWidget('Step 3:', 'Wait for approval.'),
                          titleTextWidget('Step 4:',
                              'Once approved, you will be able to start selling your products on ${AppConfig.app_name}.'),
                          titleTextWidget('Step 5:',
                              'You will be able to manage your products and orders from your dashboard.'),
                          titleTextWidget('Step 6:',
                              'You will be able to withdraw your earnings from your dashboard.'),
                          titleTextWidget('Step 7:',
                              'You will be able to manage your profile from your dashboard.'),
                          titleTextWidget('Step 8:',
                              'You will be able to manage your shop from your dashboard.'),
                        ],
                      )
              ],
            ),
          )),
          error_message.isEmpty
              ? const SizedBox()
              : FxContainer(
                  width: double.infinity,
                  child: FxText.bodySmall(
                    error_message,
                    color: Colors.black,
                  ),
                ),
          FxContainer(
            borderRadiusAll: 0,
            color: CustomTheme.primary_bg,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                mainController.userModel.status != '2'
                    ? const SizedBox()
                    : Column(
                        children: [
                          FxButton.block(
                            onPressed: () async {
                              /* await Get.to(() => BecomeDriverFormScreen(
                                  mainController.loggedInUser));
                              await mainController.getLoggedInUser();
                              refresh_status();
                              setState(() {});*/
                            },
                            child: FxText.titleLarge(
                              'UPDATE APPLICATION FORM',
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                FxButton.block(
                  onPressed: () async {
                    print("===TEST LOVE===>");
                    await LoggedInUserModel.getOnlineItems();
                    mainController.userModel =
                        await LoggedInUserModel.getLoggedInUser();
                    print(
                        "==========>${mainController.userModel.name}<=======");
                    //refresh the user model
                    if (mainController.userModel.status == '2') {
                      refresh_status();
                      return;
                    }

                    //show a dialog that the user has been registered
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                              "Are you sure you meet all the requirements to be a vendor?"),
                          actions: [
                            TextButton(
                              child: const Text("No",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("Yes",
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop();
                                do_register();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  borderRadiusAll: 100,
                  child: FxText.titleLarge(
                    is_loading
                        ? "LOADING..."
                        : mainController.userModel.status == '2'
                            ? 'REFRESH STATUS'
                            : 'REGISTER AS VENDOR',
                    color: Colors.white,
                    fontWeight: 900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool is_loading = false;
  String error_message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh_status();
  }

  void refresh_status() async {
    Utils.toast("Refreshing Status...");
    setState(() {
      is_loading = true;
    });
    await LoggedInUserModel.getOnlineItems();
    await LoggedInUserModel.getOnlineItems();
    await Future.delayed(const Duration(seconds: 1));
    await LoggedInUserModel.getOnlineItems();
    await Future.delayed(const Duration(seconds: 1));
    await mainController.getLoggedInUser();
    if (mainController.userModel.user_type == 'Vendor') {
      Utils.toast("You are now approved as a driver!");
      setState(() {
        is_loading = false;
      });
      Navigator.pop(context);
      return;
    }
    setState(() {
      is_loading = false;
    });
  }

  void do_register() async {
    mainController.userModel = await LoggedInUserModel.getLoggedInUser();
    await Get.off(() => BecomeVendorFormScreen(mainController.userModel));
  }

  titleTextWidget(String s, String t) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: MyColors.grey_20,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: MyColors.grey_60,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                s,
                style: const TextStyle(
                    color: MyColors.grey_90,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          FxText.bodyLarge(
            t,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
