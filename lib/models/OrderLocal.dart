import 'package:nudipu/models/LoggedInUserModel.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';

class OrderLocal {
  static String tableName = "orders_local";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String user = "";
  String order_state = "";
  String amount = "";
  String date_created = "";
  String payment_confirmation = "";
  String date_updated = "";
  String mail = "";
  String delivery_district = "";
  String temporary_id = "";
  String temporary_text = "";
  String description = "";
  String customer_name = "";
  String customer_phone_number_1 = "";
  String customer_phone_number_2 = "";
  String customer_address = "";
  String order_total = "";
  String order_details = "";
  String stripe_id = "";
  String stripe_text = "";
  String stripe_url = "";
  String stripe_paid = "";

  static fromJson(dynamic m) {
    OrderLocal obj = new OrderLocal();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.user = Utils.to_str(m['user'], '');
    obj.order_state = Utils.to_str(m['order_state'], '');
    obj.amount = Utils.to_str(m['amount'], '');
    obj.date_created = Utils.to_str(m['date_created'], '');
    obj.payment_confirmation = Utils.to_str(m['payment_confirmation'], '');
    obj.date_updated = Utils.to_str(m['date_updated'], '');
    obj.mail = Utils.to_str(m['mail'], '');
    obj.delivery_district = Utils.to_str(m['delivery_district'], '');
    obj.temporary_id = Utils.to_str(m['temporary_id'], '');
    obj.temporary_text = Utils.to_str(m['temporary_text'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.customer_name = Utils.to_str(m['customer_name'], '');
    obj.customer_phone_number_1 =
        Utils.to_str(m['customer_phone_number_1'], '');
    obj.customer_phone_number_2 =
        Utils.to_str(m['customer_phone_number_2'], '');
    obj.customer_address = Utils.to_str(m['customer_address'], '');
    obj.order_total = Utils.to_str(m['order_total'], '');
    obj.order_details = Utils.to_str(m['order_details'], '');
    obj.stripe_id = Utils.to_str(m['stripe_id'], '');
    obj.stripe_text = Utils.to_str(m['stripe_text'], '');
    obj.stripe_url = Utils.to_str(m['stripe_url'], '');
    obj.stripe_paid = Utils.to_str(m['stripe_paid'], '');

    return obj;
  }

  static Future<List<OrderLocal>> getLocalData({String where = "1"}) async {
    List<OrderLocal> data = [];
    if (!(await OrderLocal.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(OrderLocal.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<OrderLocal>> get_items({String where = '1'}) async {
    List<OrderLocal> data = await getLocalData(where: where);
    return data;
  }

  save() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        tableName,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'user': user,
      'order_state': order_state,
      'amount': amount,
      'date_created': date_created,
      'payment_confirmation': payment_confirmation,
      'date_updated': date_updated,
      'mail': mail,
      'delivery_district': delivery_district,
      'temporary_id': temporary_id,
      'temporary_text': temporary_text,
      'description': description,
      'customer_name': customer_name,
      'customer_phone_number_1': customer_phone_number_1,
      'customer_phone_number_2': customer_phone_number_2,
      'customer_address': customer_address,
      'order_total': order_total,
      'order_details': order_details,
      'stripe_id': stripe_id,
      'stripe_text': stripe_text,
      'stripe_url': stripe_url,
      'stripe_paid': stripe_paid,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",user TEXT"
        ",order_state TEXT"
        ",amount TEXT"
        ",date_created TEXT"
        ",payment_confirmation TEXT"
        ",date_updated TEXT"
        ",mail TEXT"
        ",delivery_district TEXT"
        ",temporary_id TEXT"
        ",temporary_text TEXT"
        ",description TEXT"
        ",customer_name TEXT"
        ",customer_phone_number_1 TEXT"
        ",customer_phone_number_2 TEXT"
        ",customer_address TEXT"
        ",order_total TEXT"
        ",order_details TEXT"
        ",stripe_id TEXT"
        ",stripe_text TEXT"
        ",stripe_url TEXT"
        ",stripe_paid TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await OrderLocal.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(OrderLocal.tableName);
  }

  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where: 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  //get order OrderLocal
  static Future<OrderLocal> getOrder(LoggedInUserModel u) async {
    //get latest order
    List<OrderLocal> orders = await getLocalData(where: ' id = 1 ');
    OrderLocal o = OrderLocal();
    if (orders.isNotEmpty) {
      o = orders[0];
    }
    if (o.id < 1) {
      o.id = 1;
    }
    o.user = o.user.isEmpty ? u.id.toString() : o.user;
    o.mail = o.mail.isEmpty ? u.email : o.mail;
    o.customer_name = o.customer_name.isEmpty ? u.name : o.customer_name;
    o.customer_name = o.customer_name.trim().isEmpty
        ? "${u.first_name} ${u.last_name}"
        : o.customer_name;
    o.customer_phone_number_1 = o.customer_phone_number_1.isEmpty
        ? u.phone_number
        : o.customer_phone_number_1;
    o.customer_phone_number_2 = o.customer_phone_number_2.isEmpty
        ? u.phone_number_2
        : o.customer_phone_number_2;
    o.customer_address =
        o.customer_address.isEmpty ? u.address : o.customer_address;

    return o;
  }

  //has delivery info
  bool hasDeliveryInfo() {
    return customer_address.isNotEmpty &&
        customer_name.isNotEmpty &&
        delivery_district.isNotEmpty &&
        customer_phone_number_1.isNotEmpty;
  }

}
