import 'package:nudipu/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';

class ServiceProvider {
  static String endPoint = "service-providers";
  static String tableName = "service_providers";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String administrator_id = "";
  String name = "";
  String about = "";
  String address = "";
  String parish = "";
  String village = "";
  String phone_number = "";
  String email = "";
  String district_id = "";
  String subcounty_id = "";
  String website = "";
  String phone_number_2 = "";
  String services_offered = "";
  String photo = "";
  String gps_latitude = "";
  String gps_longitude = "";
  String status = "";
  String deleted_at = "";
  String subcounty_text = "";

  static fromJson(dynamic m) {
    ServiceProvider obj = ServiceProvider();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.about = Utils.to_str(m['about'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.parish = Utils.to_str(m['parish'], '');
    obj.village = Utils.to_str(m['village'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.website = Utils.to_str(m['website'], '');
    obj.phone_number_2 = Utils.to_str(m['phone_number_2'], '');
    obj.services_offered = Utils.to_str(m['services_offered'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.gps_latitude = Utils.to_str(m['gps_latitude'], '');
    obj.gps_longitude = Utils.to_str(m['gps_longitude'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.deleted_at = Utils.to_str(m['deleted_at'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');

    return obj;
  }

  static Future<List<ServiceProvider>> getLocalData({String where = "1"}) async {
    List<ServiceProvider> data = [];
    if (!(await ServiceProvider.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(ServiceProvider.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(ServiceProvider.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ServiceProvider>> getItems({String where = '1'}) async {
    List<ServiceProvider> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ServiceProvider.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      ServiceProvider.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<ServiceProvider>> getOnlineItems() async {
    List<ServiceProvider> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(ServiceProvider.endPoint, {}));

    if (resp.code != 1) {
      return [];
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await ServiceProvider.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ServiceProvider sub = ServiceProvider.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {}
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {}
      });
    }

    return [];

    return data;
  }

  save() async {
    Database db = await Utils.dbInit();
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
      'administrator_id': administrator_id,
      'name': name,
      'about': about,
      'address': address,
      'parish': parish,
      'village': village,
      'phone_number': phone_number,
      'email': email,
      'district_id': district_id,
      'subcounty_id': subcounty_id,
      'website': website,
      'phone_number_2': phone_number_2,
      'services_offered': services_offered,
      'photo': photo,
      'gps_latitude': gps_latitude,
      'gps_longitude': gps_longitude,
      'status': status,
      'deleted_at': deleted_at,
      'subcounty_text': subcounty_text,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${ServiceProvider.tableName} (  "
        "id INTEGER PRIMARY KEY,"
        " created_at TEXT,"
        " updated_at TEXT,"
        " administrator_id TEXT,"
        " name TEXT,"
        " about TEXT,"
        " address TEXT,"
        " parish TEXT,"
        " village TEXT,"
        " phone_number TEXT,"
        " email TEXT,"
        " district_id TEXT,"
        " subcounty_id TEXT,"
        " website TEXT,"
        " phone_number_2 TEXT,"
        " services_offered TEXT,"
        " photo TEXT,"
        " gps_latitude TEXT,"
        " gps_longitude TEXT,"
        " status TEXT,"
        " deleted_at TEXT,"
        " subcounty_text TEXT)";

    try {
      //await db.delete(tableName);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await ServiceProvider.initTable())) {
      return;
    }
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
