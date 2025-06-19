import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:nudipu/utils/Utils.dart';

import '../../../controllers/MainController.dart';
import '../../../models/ProductCategory.dart';
import '../../../theme/app_theme.dart';
import '../../account/account_vefication_screen.dart';
import '../../account/uverified_popup.dart';
import '../../cart/CartScreen.dart';
import '../../shop/ProductSearchScreen.dart';
import '../../shop/ProductsScreen.dart';
import '../../vendors/VendorsScreen.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/category_picker_sheet.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/promotional_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/vendor_list.dart';

// Changed to a StatelessWidget since GetX manages all the state.
class SectionDashboard extends StatefulWidget {
  const SectionDashboard({super.key});

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard> {
  // Get the instance of your MainController.
  // GetX will ensure it's the same instance used throughout your app.
  final MainController controller = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to run logic after the first frame is built.
    // This is a safe place to show dialogs or check for updates.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
      _checkVerification();
    });
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint("Error checking for update: $e");
    }
  }

  void _checkVerification() {
    // The userModel is already loaded by the controller's init method.
    if (controller.userModel.id < 1 ||
        controller.userModel.complete_profile == 'Yes') {
      return;
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return UnverifiedAccountPopup(controller.userModel.email, () async {
          await Get.to(() => AccountVerificationScreen(controller.userModel));
          // After returning, refresh the user's data.
          await controller.getLoggedInUser();
        });
      },
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          CategoryPickerBottomSheet(categories: controller.categories.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    Utils.overlay();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          title: Text(
            'Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          toolbarHeight: 0,
          systemOverlayStyle: Utils.overlay()),
      // The Obx widget listens to your controller's Rx variables
      // and automatically rebuilds the UI when they change.
      body: Obx(
        () {
          // You can now derive lists directly from the controller's state.
          final List<ProductCategory> banners = controller.categories.value
              .whereType<ProductCategory>()
              .where((c) => c.show_in_banner.toString().toLowerCase() == 'yes')
              .toList();

          final List<ProductCategory> categories = controller.categories
              .whereType<ProductCategory>()
              .where((c) => c.show_in_categories == 'Yes')
              .toList();

          return Column(
            children: [
              DashboardAppBar(
                onSearchTap: () => Get.to(() => const ProductSearchScreen()),
                onFilterTap: _showCategoryPicker,
              ),
              Expanded(
                child: RefreshIndicator(
                  // onRefresh now calls the refreshData method in your controller.
                  onRefresh: () => controller.refreshData(),
                  color: CustomTheme.primary,
                  backgroundColor: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      // Pass the derived lists to your modular widgets.
                      PromotionalBanner(banners: banners),

                      SectionHeader(
                        title: 'Top Categories',
                        onViewAll: _showCategoryPicker,
                      ),

                      CategoryGrid(categories: categories),

                      SectionHeader(
                        title: 'Featured Vendors',
                        onViewAll: () => Get.to(() => const VendorsScreen()),
                      ),

                      VendorList(
                          vendors: controller
                              .vendors.value), // Placeholder for vendors

                      // Placeholder for vendors

                      SectionHeader(
                        title: 'Top Selling',
                        onViewAll: () => Get.to(() => ProductsScreen({})),
                      ),

                      ProductGrid(products: controller.products.value),

                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                ),
              ),
              (controller.cartItems.isEmpty)
                  ? const SizedBox()
                  : Obx(() => InkWell(
                        onTap: () {
                          Get.to(() => const CartScreen());
                        },
                        child: Container(
                          color: CustomTheme.primary,
                          child: Row(
                            children: [
                              FxSpacing.width(8),
                              FxText.titleSmall(
                                "You have ${controller.cartItems.length} items in cart.",
                                color: Colors.white,
                              ),
                              const Spacer(),
                              FxContainer(
                                margin: const EdgeInsets.only(
                                    right: 5, top: 5, bottom: 5),
                                color: CustomTheme.bg_primary_light,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 5, top: 4, bottom: 2),
                                child: Row(
                                  children: [
                                    FxText.bodySmall(
                                      "CHECKOUT",
                                      fontWeight: 900,
                                      color: CustomTheme.primaryDark,
                                    ),
                                    const Icon(
                                      FeatherIcons.chevronRight,
                                      color: CustomTheme.primaryDark,
                                      size: 16,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
            ],
          );
        },
      ),
    );
  }
}
