import 'package:nudipu/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';

class Person {
  static String endPoint = "people";
  static String tableName = "people";

  int id = 0;
  String created_at = "";
  String association_id = "";
  String administrator_id = "";
  String administrator_text = "";
  String association_text = "";
  String group_id = "";
  String group_text = "";
  String name = "";
  String address = "";
  String parish = "";
  String village = "";
  String phone_number = "";
  String email = "";
  String district_id = "";
  String district_text = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String disability_id = "";
  String disability_text = "";
  String phone_number_2 = "";
  String dob = DateTime(1990).toString();
  String sex = "";
  String education_level = "";
  String employment_status = "";
  String has_caregiver = "";
  String has_group = "";
  String caregiver_name = "";
  String caregiver_sex = "";
  String caregiver_phone_number = "";
  String caregiver_age = "";
  String caregiver_relationship = "";
  String photo = "";
  String deleted_at = "";
  String status = "";

  static Person fromJson(dynamic m) {
    Person obj = Person();
    if (m == null) {
      return obj;
    }
    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.association_id = Utils.to_str(m['association_id'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');

    obj.association_text = Utils.to_str(m['association_text'], '');
    obj.group_id = Utils.to_str(m['group_id'], '');
    obj.group_text = Utils.to_str(m['group_text'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.parish = Utils.to_str(m['parish'], '');
    obj.village = Utils.to_str(m['village'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.disability_id = Utils.to_str(m['disability_id'], '');
    obj.disability_text = Utils.to_str(m['disability_text'], '');
    obj.phone_number_2 = Utils.to_str(m['phone_number_2'], '');
    obj.dob = Utils.to_str(m['dob'], '');
    obj.sex = Utils.to_str(m['sex'], '');
    obj.education_level = Utils.to_str(m['education_level'], '');
    obj.employment_status = Utils.to_str(m['employment_status'], '');
    obj.has_caregiver = Utils.to_str(m['has_caregiver'], '');
    obj.caregiver_name = Utils.to_str(m['caregiver_name'], '');
    obj.caregiver_sex = Utils.to_str(m['caregiver_sex'], '');
    obj.caregiver_phone_number = Utils.to_str(m['caregiver_phone_number'], '');
    obj.caregiver_age = Utils.to_str(m['caregiver_age'], '');
    obj.caregiver_relationship = Utils.to_str(m['caregiver_relationship'], '');
    obj.photo = Utils.to_str(m['photo'], '');

    if (obj.photo.isEmpty) {
      obj.photo = "${AppConfig.MAIN_SITE_URL}/storage/no_image.jpg";
    } else if (!obj.photo.contains('http')) {
      obj.photo = "${AppConfig.MAIN_SITE_URL}/storage/${obj.photo}";
    }

    obj.deleted_at = Utils.to_str(m['deleted_at'], '');
    obj.status = Utils.to_str(m['status'], '');

    return obj;
  }

  static Future<List<Person>> getItems({String where = '1'}) async {
    List<Person> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await Person.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      Person.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<Person>> getLocalData({String where = "1"}) async {
    List<Person> data = [];
    if (!(await Person.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return data;
    }

    print("===> where $where <==== ");

    List<Map> maps = await db.query(Person.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(Person.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<Person>> getOnlineItems() async {
    List<Person> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(Person.endPoint, {}));

    print(resp.message);
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
        await Person.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {

          Person sub = Person.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {

        }
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
      'association_id': association_id,
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'association_text': association_text,
      'group_id': group_id,
      'group_text': group_text,
      'name': name,
      'address': address,
      'parish': parish,
      'village': village,
      'phone_number': phone_number,
      'email': email,
      'district_id': district_id,
      'district_text': district_text,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'disability_id': disability_id,
      'disability_text': disability_text,
      'phone_number_2': phone_number_2,
      'dob': dob,
      'sex': sex,
      'education_level': education_level,
      'employment_status': employment_status,
      'has_caregiver': has_caregiver,
      'caregiver_name': caregiver_name,
      'caregiver_sex': caregiver_sex,
      'caregiver_phone_number': caregiver_phone_number,
      'caregiver_age': caregiver_age,
      'caregiver_relationship': caregiver_relationship,
      'photo': photo,
      'status': status,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }

    String sql =
        "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, created_at TEXT, association_id TEXT, administrator_id TEXT, administrator_text TEXT, association_text TEXT, group_id TEXT, group_text TEXT, name TEXT, address TEXT, parish TEXT, village TEXT, phone_number TEXT, email TEXT, district_id TEXT, district_text TEXT, subcounty_id TEXT, subcounty_text TEXT, disability_id TEXT, disability_text TEXT, phone_number_2 TEXT, dob TEXT, sex TEXT, education_level TEXT, employment_status TEXT, has_caregiver TEXT, caregiver_name TEXT, caregiver_sex TEXT, caregiver_phone_number TEXT, caregiver_age TEXT, caregiver_relationship TEXT, photo TEXT, deleted_at TEXT, status TEXT)";

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
    if (!(await Person.initTable())) {
      return;
    }
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
