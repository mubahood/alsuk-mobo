import 'package:nudipu/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';

class NewsPost {
  static String endPoint = "news-posts";
  static String tableName = "news_posts";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String title = "";
  String details = "";
  String administrator_id = "";
  String post_category_id = "";
  String views = "";
  String description = "";
  String photo = "";
  String post_category_text = "";


  static fromJson(dynamic m) {
    NewsPost obj = NewsPost();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'],'');
    obj.updated_at = Utils.to_str(m['updated_at'],'');
    obj.title = Utils.to_str(m['title'],'');
    obj.details = Utils.to_str(m['details'],'');
    obj.administrator_id = Utils.to_str(m['administrator_id'],'');
    obj.post_category_id = Utils.to_str(m['post_category_id'],'');
    obj.views = Utils.to_str(m['views'],'');
    obj.description = Utils.to_str(m['description'],'');
    obj.photo = Utils.to_str(m['photo'],'');
    obj.post_category_text = Utils.to_str(m['post_category_text'],'');

    return obj;
  }




  static Future<List<NewsPost>> getLocalData({String where = "1"}) async {
    List<NewsPost> data = [];
    if (!(await NewsPost.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(NewsPost.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(NewsPost.fromJson(maps[i]));
    });

    return data;
  }


  static Future<List<NewsPost>> getItems({String where = '1'}) async {
    List<NewsPost> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await NewsPost.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      NewsPost.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<NewsPost>> getOnlineItems() async {
    List<NewsPost> data = [];

    RespondModel resp =
    RespondModel(await Utils.http_get(NewsPost.endPoint, {}));

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
        await NewsPost.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          NewsPost sub = NewsPost.fromJson(x);
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
      'updated_at' : updated_at,
      'title' : title,
      'details' : details,
      'administrator_id' : administrator_id,
      'post_category_id' : post_category_id,
      'views' : views,
      'description' : description,
      'photo' : photo,
      'post_category_text' : post_category_text,

    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }

    String sql = "CREATE TABLE  IF NOT EXISTS  ${NewsPost.tableName} (  "
        "id INTEGER PRIMARY KEY,"
        " created_at TEXT,"
        " updated_at TEXT,"
        " title TEXT,"
        " details TEXT,"
        " administrator_id TEXT,"
        " post_category_id TEXT,"
        " views TEXT,"
        " description TEXT,"
        " photo TEXT,"
        " post_category_text TEXT)";

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
    if (!(await NewsPost.initTable())) {
      return;
    }
    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}