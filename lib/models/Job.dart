import 'package:nudipu/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';

class Job {
  static String endPoint = "jobs";
  static String tableName = "jobs";

  int id = 0;
  String created_at = "";
  String administrator_id = "";
  String title = "";
  String short_description = "";
  String details = "";
  String nature_of_job = "";
  String minimum_academic_qualification = "";
  String required_expirience = "";
  String expirience_period = "";
  String category = "";
  String photo = "";
  String how_to_apply = "";
  String whatsapp = "";
  String subcounty_id = "";
  String district_id = "";
  String deadline = "";
  String slots = "";
  String subcounty_text = "";


  static fromJson(dynamic m) {
    Job obj = Job();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'],'');

    obj.administrator_id = Utils.to_str(m['administrator_id'],'');
    obj.title = Utils.to_str(m['title'],'');
    obj.short_description = Utils.to_str(m['short_description'],'');
    obj.details = Utils.to_str(m['details'],'');
    obj.nature_of_job = Utils.to_str(m['nature_of_job'],'');
    obj.minimum_academic_qualification = Utils.to_str(m['minimum_academic_qualification'],'');
    obj.required_expirience = Utils.to_str(m['required_expirience'],'');
    obj.expirience_period = Utils.to_str(m['expirience_period'],'');
    obj.category = Utils.to_str(m['category'],'');
    obj.photo = Utils.to_str(m['photo'],'');
    obj.how_to_apply = Utils.to_str(m['how_to_apply'],'');
    obj.whatsapp = Utils.to_str(m['whatsapp'],'');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'],'');
    obj.district_id = Utils.to_str(m['district_id'],'');
    obj.deadline = Utils.to_str(m['deadline'],'');
    obj.slots = Utils.to_str(m['slots'],'');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'],'');

    if (obj.photo.isEmpty) {
      obj.photo = "${AppConfig.MAIN_SITE_URL}/storage/no_image.jpg";
    } else if (!obj.photo.contains('http')) {
      obj.photo = "${AppConfig.MAIN_SITE_URL}/storage/${obj.photo}";
    }


    return obj;
  }




  static Future<List<Job>> getLocalData({String where = "1"}) async {
    List<Job> data = [];
    if (!(await Job.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(Job.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(Job.fromJson(maps[i]));
    });

    return data;
  }


  static Future<List<Job>> getItems({String where = '1'}) async {
    List<Job> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await Job.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      Job.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<Job>> getOnlineItems() async {
    List<Job> data = [];

    RespondModel resp =
    RespondModel(await Utils.http_get(Job.endPoint, {}));

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
        await Job.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          Job sub = Job.fromJson(x);
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
      'id' : id,
      'created_at' : created_at,
      'administrator_id' : administrator_id,
      'title' : title,
      'short_description' : short_description,
      'details' : details,
      'nature_of_job' : nature_of_job,
      'minimum_academic_qualification' : minimum_academic_qualification,
      'required_expirience' : required_expirience,
      'expirience_period' : expirience_period,
      'category' : category,
      'photo' : photo,
      'how_to_apply' : how_to_apply,
      'whatsapp' : whatsapp,
      'subcounty_id' : subcounty_id,
      'district_id' : district_id,
      'deadline' : deadline,
      'slots' : slots,
      'subcounty_text' : subcounty_text,

    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${Job.tableName} (  "
        "id INTEGER PRIMARY KEY,"
        " created_at TEXT,"
        " administrator_id TEXT,"
        " title TEXT,"
        " short_description TEXT,"
        " details TEXT,"
        " nature_of_job TEXT,"
        " minimum_academic_qualification TEXT,"
        " required_expirience TEXT,"
        " expirience_period TEXT,"
        " category TEXT,"
        " photo TEXT,"
        " how_to_apply TEXT,"
        " whatsapp TEXT,"
        " subcounty_id TEXT,"
        " district_id TEXT,"
        " deadline TEXT,"
        " slots TEXT,"
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
    if (!(await Job.initTable())) {
      return;
    }
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}