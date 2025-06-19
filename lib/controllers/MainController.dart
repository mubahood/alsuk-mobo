// ignore: file_names
// ignore: file_names
import 'package:get/get.dart';
import 'package:nudipu/models/CartItem.dart';
import 'package:nudipu/models/LoggedInUserModel.dart';
import 'package:nudipu/models/Product.dart';
import 'package:nudipu/utils/Utils.dart';

import '../models/ChatHead.dart';
import '../models/OrderOnline.dart';
import '../models/ProductCategory.dart';
import '../models/VendorModel.dart';

class MainController extends GetxController {
  var count = 0.obs;
  double tot = 0;

  RxList<dynamic> chatHeads = <ChatHead>[].obs;
  RxList<dynamic> myProducts = <Product>[].obs;
  RxList<dynamic> products = <Product>[].obs;
  RxList<dynamic> vendors = <VendorModel>[].obs;
  RxList<dynamic> cartItems = <CartItem>[].obs;
  RxList<dynamic> myOrders = <OrderOnline>[].obs;
  RxList<dynamic> categories = <ProductCategory>[].obs;
  RxList<String> cartItemsIDs = <String>[].obs;

  LoggedInUserModel userModel = LoggedInUserModel();

  Future<void> refreshData() async {
    // This will re-fetch all the necessary data for the dashboard
    await init();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await getLoggedInUser();
    getCartItems();
    getProducts();
    getCategories();
    getMyProducts();
    getChatHeads();
    /* await getMyClasses();
    await getMySubjects();
    await getMyStudents();*/
  }

  Future<void> getLoggedInUser() async {
    userModel = await LoggedInUserModel.getLoggedInUser();
    return;
  }

  Future<void> addToCart(
    Product pro, {
    String color = "",
    String size = "",
  }) async {
    await getCartItems();
    for (var element in cartItems) {
      if (element.product_id == pro.id.toString()) {
        return;
      }
    }

    //await CartItem.deleteAll();
    CartItem c = CartItem();
    c.id = pro.id;
    c.product_id = pro.id.toString();
    c.product_name = pro.name;
    c.product_price_1 = pro.price_1;
    c.product_quantity = '1';
    c.product_feature_photo = pro.feature_photo;
    c.color = color;
    c.size = size;
    await c.save();
    await getCartItems();
  }

  Future<void> getProducts() async {
    products.value = await Product.getItems();
    vendors.value = await VendorModel.get_items();
    //shuffle products.value
    products.shuffle();
    products.shuffle();
    update();
    return;
  }

  Future<void> getMyProducts() async {
    if (userModel.id < 1) {
      await getLoggedInUser();
    }
    if (userModel.id < 1) {
      myProducts.clear();
      return;
    }
    myProducts.clear();
    for (var element
        in (await Product.getItems(where: 'user = ${userModel.id}'))) {
      myProducts.add(element);
    }
    myProducts.sort((a, b) => b.id.compareTo(a.id));
    update();
    return;
  }

  bool listenersStarted = false;

  Future<void> getChatHeads() async {
    if (userModel.id < 1) {
      await getLoggedInUser();
    }
    if (userModel.id < 1) {
      chatHeads.clear();
      return;
    }
    chatHeads.clear();
    for (var element in (await ChatHead.get_items(userModel))) {
      element.myUnread(userModel);
      chatHeads.add(element);
    }
    update();
    return;
  }

  Future<void> getCartItems() async {
    cartItems.clear();
    cartItemsIDs.clear();
    tot = 0;
    cartItemsIDs.value.clear();
    for (var element in (await CartItem.getItems())) {
      cartItems.add(element);
      cartItemsIDs.add(element.id.toString());
      if (element.pro.id < 1) {
        await element.getPro();
      }
      if (element.pro.id > 0) {
        if (element.pro.p_type == 'Yes') {
          element.pro.getPrices();
          int qty = Utils.int_parse(element.product_quantity);
          for (var price in element.pro.pricesList) {
            if (qty >= price.min_qty && qty <= price.max_qty) {
              element.product_price_1 = price.price;
              break;
            }
          }
        } else {
          element.product_price_1 = element.pro.price_1;
        }
        tot += Utils.double_parse(element.product_quantity) *
            Utils.double_parse(element.product_price_1);
      } else {
        Utils.toast("Product ${element.product_name} not found.");
      }
      update();
    }
  }

  getOrders() async {
    myOrders.value = await OrderOnline.getItems();
    update();
  }

  Future<void> removeFromCart(String id) async {
    await CartItem.deleteAt("product_id = '$id'");
    await getCartItems();
    update();
  }

  increment() => count++;

  decrement() => count--;

  Future<void> getCategories() async {
    categories.value = await ProductCategory.getItems();
    update();
  }
}
