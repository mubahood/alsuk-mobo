// /*
// import 'package:nudipu/utils/Utils.dart';
// import 'package:sqflite/sqflite.dart';
//
// import 'RespondModel.dart';
//
// class OrderOnline2 {
//   static String endPoint = "orders";
//   static String tableName = "ordersOnline";
//
//   int id = 0;
//   String items = "";
//   String created_at = "";
//   String order_state = "";
//   String amount = "";
//   String payment_confirmation = "";
//   String description = "";
//   String mail = "";
//   String customer_name = "";
//   String customer_phone_number_1 = "";
//   String customer_phone_number_2 = "";
//   String customer_address = "";
//   String order_total = "";
//   String order_details = "";
//   String user = "";
//   String delivery_district = "";
//
//   static fromJson(dynamic m) {
//     OrderOnline2 obj = OrderOnline2();
//     if (m == null) {
//       return obj;
//     }
//
//     obj.id = Utils.int_parse(m['id']);
//     obj.items = Utils.to_str(m['items'], '');
//     obj.created_at = Utils.to_str(m['created_at'], '');
//     obj.order_state = Utils.to_str(m['order_state'], '');
//     obj.amount = Utils.to_str(m['amount'], '');
//     obj.payment_confirmation = Utils.to_str(m['payment_confirmation'], '');
//     obj.description = Utils.to_str(m['description'], '');
//     obj.mail = Utils.to_str(m['mail'], '');
//     obj.customer_name = Utils.to_str(m['customer_name'], '');
//     obj.customer_phone_number_1 =
//         Utils.to_str(m['customer_phone_number_1'], '');
//     obj.customer_phone_number_2 =
//         Utils.to_str(m['customer_phone_number_2'], '');
//     obj.customer_address = Utils.to_str(m['customer_address'], '');
//     obj.order_total = Utils.to_str(m['order_total'], '');
//     obj.order_details = Utils.to_str(m['order_details'], '');
//     obj.user = Utils.to_str(m['user'], '');
//     obj.delivery_district = Utils.to_str(m['delivery_district'], '');
//
//     return obj;
//   }
//
//   static Future<List<OrderOnline2>> getLocalData({String where = "1"}) async {
//     List<OrderOnline2> data = [];
//     if (!(await OrderOnline2.initTable())) {
//       Utils.toast("Failed to init dynamic store.");
//       return data;
//     }
//
//     Database db = await Utils.dbInit();
//     if (!db.isOpen) {
//       return data;
//     }
//
//     List<Map> maps = await db.query(OrderOnline2.tableName, where: where);
//
//     if (maps.isEmpty) {
//       return data;
//     }
//     List.generate(maps.length, (i) {
//       data.add(OrderOnline2.fromJson(maps[i]));
//     });
//
//     return data;
//   }
//
//   static Future<List<OrderOnline2>> getItems({String where = '1'}) async {
//     List<OrderOnline2> data = await getLocalData(where: where);
//     if (data.isEmpty) {
//       await OrderOnline2.getOnlineItems();
//       data = await getLocalData(where: where);
//     } else {
//       data = await getLocalData(where: where);
//       OrderOnline2.getOnlineItems();
//     }
//     data.sort((a, b) => b.id.compareTo(a.id));
//     return data;
//   }
//
//   static Future<List<OrderOnline2>> getOnlineItems() async {
//     List<OrderOnline2> data = [];
//
//     RespondModel resp =
//         RespondModel(await Utils.http_get(OrderOnline2.endPoint, {}));
//
//     print(resp.data);
//     print(resp.message);
//     if (resp.code != 1) {
//       return [];
//     }
//
//     Database db = await Utils.dbInit();
//     if (!db.isOpen) {
//       Utils.toast("Failed to init local store.");
//       return [];
//     }
//
//     if (resp.data.runtimeType.toString().contains('List')) {
//       if (await Utils.is_connected()) {
//         await OrderOnline2.deleteAll();
//       }
//
//       await db.transaction((txn) async {
//         var batch = txn.batch();
//
//         for (var x in resp.data) {
//           OrderOnline2 sub = OrderOnline2.fromJson(x);
//           try {
//             batch.insert(tableName, sub.toJson(),
//                 conflictAlgorithm: ConflictAlgorithm.replace);
//           } catch (e) {}
//         }
//
//         try {
//           await batch.commit(continueOnError: true);
//         } catch (e) {}
//       });
//     }
//
//     return [];
//
//     return data;
//   }
//
//   save() async {
//     Database db = await Utils.dbInit();
//     if (!db.isOpen) {
//       Utils.toast("Failed to init local store.");
//       return;
//     }
//
//     await initTable();
//
//     try {
//       await db.insert(
//         tableName,
//         toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     } catch (e) {
//       Utils.toast("Failed to save student because ${e.toString()}");
//     }
//   }
//
//   toJson() {
//     return {
//       'id': id,
//       'items': items,
//       'created_at': created_at,
//       'order_state': order_state,
//       'amount': amount,
//       'payment_confirmation': payment_confirmation,
//       'description': description,
//       'mail': mail,
//       'customer_name': customer_name,
//       'customer_phone_number_1': customer_phone_number_1,
//       'customer_phone_number_2': customer_phone_number_2,
//       'customer_address': customer_address,
//       'order_total': order_total,
//       'order_details': order_details,
//       'user': user,
//       'delivery_district': delivery_district,
//     };
//   }
//
//   static Future<bool> initTable() async {
//     Database db = await Utils.dbInit();
//     if (!db.isOpen) {
//       return false;
//     }
//
//     String sql = "CREATE TABLE  IF NOT EXISTS  ${OrderOnline2.tableName} (  "
//         "id INTEGER PRIMARY KEY,"
//         "items TEXT,"
//         "created_at TEXT,"
//         "order_state TEXT,"
//         "amount TEXT,"
//         "payment_confirmation TEXT,"
//         "description TEXT,"
//         "mail TEXT,"
//         "customer_name TEXT,"
//         "customer_phone_number_1 TEXT,"
//         "customer_phone_number_2 TEXT,"
//         "customer_address TEXT,"
//         "order_total TEXT,"
//         "order_details TEXT,"
//         "user TEXT,"
//         "delivery_district TEXT)";
//     try {
//       //await db.execute('DROP TABLE $tableName');
//
//       await db.execute(sql);
//     } catch (e) {
//       Utils.log('Failed to create table because ${e.toString()}');
//
//       return false;
//     }
//
//     return true;
//   }
//
//   static deleteAll() async {
//     if (!(await OrderOnline2.initTable())) {
//       return;
//     }
//     Database db = await Utils.dbInit();
//     if (!db.isOpen) {
//       return false;
//     }
//     await db.delete(tableName);
//   }
// }
// */
