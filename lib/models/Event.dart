import 'package:nudipu/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';

class Event {
  static String endPoint = "events";
  static String tableName = "events";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String title = "";
  String theme = "";
  String photo = "";
  String details = "";
  String prev_event_title = "";
  String number_of_attendants = "";
  String number_of_speakers = "";
  String number_of_experts = "";
  String venue_name = "";
  String venue_photo = "";
  String venue_map_photo = "";
  String event_date = "";
  String address = "";
  String gps_latitude = "";
  String gps_longitude = "";
  String video = "";

  static fromJson(dynamic m) {
    Event obj = Event();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.theme = Utils.to_str(m['theme'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.prev_event_title = Utils.to_str(m['prev_event_title'], '');
    obj.number_of_attendants = Utils.to_str(m['number_of_attendants'], '');
    obj.number_of_speakers = Utils.to_str(m['number_of_speakers'], '');
    obj.number_of_experts = Utils.to_str(m['number_of_experts'], '');
    obj.venue_name = Utils.to_str(m['venue_name'], '');
    obj.venue_photo = Utils.to_str(m['venue_photo'], '');
    obj.venue_map_photo = Utils.to_str(m['venue_map_photo'], '');
    obj.event_date = Utils.to_str(m['event_date'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.gps_latitude = Utils.to_str(m['gps_latitude'], '');
    obj.gps_longitude = Utils.to_str(m['gps_longitude'], '');
    obj.video = Utils.to_str(m['video'], '');

    return obj;
  }

  static Future<List<Event>> getLocalData({String where = "1"}) async {
    List<Event> data = [];
    if (!(await Event.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(Event.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(Event.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<Event>> getItems({String where = '1'}) async {
    List<Event> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await Event.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      Event.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<Event>> getOnlineItems() async {
    List<Event> data = [];

    RespondModel resp = RespondModel(await Utils.http_get(Event.endPoint, {}));

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
        await Event.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          Event sub = Event.fromJson(x);
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
      'title': title,
      'theme': theme,
      'photo': photo,
      'details': details,
      'prev_event_title': prev_event_title,
      'number_of_attendants': number_of_attendants,
      'number_of_speakers': number_of_speakers,
      'number_of_experts': number_of_experts,
      'venue_name': venue_name,
      'venue_photo': venue_photo,
      'venue_map_photo': venue_map_photo,
      'event_date': event_date,
      'address': address,
      'gps_latitude': gps_latitude,
      'gps_longitude': gps_longitude,
      'video': video,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${Event.tableName} (  "
        "id INTEGER PRIMARY KEY,"
        " created_at TEXT,"
        " updated_at TEXT,"
        " title TEXT,"
        " theme TEXT,"
        " photo TEXT,"
        " details TEXT,"
        " prev_event_title TEXT,"
        " number_of_attendants TEXT,"
        " number_of_speakers TEXT,"
        " number_of_experts TEXT,"
        " venue_name TEXT,"
        " venue_photo TEXT,"
        " venue_map_photo TEXT,"
        " event_date TEXT,"
        " address TEXT,"
        " gps_latitude TEXT,"
        " gps_longitude TEXT,"
        " video TEXT)";

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
    if (!(await Event.initTable())) {
      return;
    }
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
