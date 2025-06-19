import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class LoggedInUserModel {
/*  static String end_point = "";*/
  static String tableName = "logged_in_user";
  int id = 0;
  String username = "";
  String phone_number_2 = "";
  String password = "";
  String first_name = "";
  String last_name = "";
  String reg_date = "";
  String last_seen = "";
  String email = "";
  String approved = "";
  String profile_photo = "";
  String user_type = "";
  String sex = "";
  String reg_number = "";
  String country = "";
  String occupation = "";
  String profile_photo_large = "";
  String phone_number = "";
  String location_lat = "";
  String location_long = "";
  String facebook = "";
  String twitter = "";
  String whatsapp = "";
  String linkedin = "";
  String website = "";
  String other_link = "";
  String cv = "";
  String language = "";
  String about = "";
  String address = "";
  String created_at = "";
  String updated_at = "";
  String avatar = "";
  String name = "";
  String campus_id = "";
  String campus_text = "";
  String remember_token = "";
  String complete_profile = "";
  String title = "";
  String dob = "";
  String intro = "";
  String business_name = "";
  String business_license_number = "";
  String business_license_issue_authority = "";
  String business_license_issue_date = "";
  String business_license_validity = "";
  String business_address = "";
  String business_phone_number = "";
  String business_whatsapp = "";
  String business_email = "";
  String business_logo = "";
  String business_cover_photo = "";
  String business_cover_details = "";
  String status = "";

  static Future<String> get_token() async {
    String token = await Utils.getToken();

    return token;
  }

  static Future<LoggedInUserModel> getLoggedInUser() async {
    LoggedInUserModel item = LoggedInUserModel();

    if (!await initTable()) {
      Utils.toast('Failed to create user storage.');
      return item;
    }

    Database db = await Utils.dbInit();
    if (!db.isOpen) {
      return item;
    }

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    List.generate(maps.length, (i) {
      item = LoggedInUserModel.fromJson(maps[i]);
    });
    return item;
  }

  static fromJson(dynamic m) {
    LoggedInUserModel obj = LoggedInUserModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.username = Utils.to_str(m['username'], '');
    obj.password = Utils.to_str(m['password'], '');
    obj.first_name = Utils.to_str(m['first_name'], '');
    obj.last_name = Utils.to_str(m['last_name'], '');
    obj.reg_date = Utils.to_str(m['reg_date'], '');
    obj.last_seen = Utils.to_str(m['last_seen'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.approved = Utils.to_str(m['approved'], '');
    obj.profile_photo = Utils.to_str(m['profile_photo'], '');
    obj.user_type = Utils.to_str(m['user_type'], '');
    obj.sex = Utils.to_str(m['sex'], '');
    obj.reg_number = Utils.to_str(m['reg_number'], '');
    obj.country = Utils.to_str(m['country'], '');
    obj.occupation = Utils.to_str(m['occupation'], '');
    obj.profile_photo_large = Utils.to_str(m['profile_photo_large'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.location_lat = Utils.to_str(m['location_lat'], '');
    obj.location_long = Utils.to_str(m['location_long'], '');
    obj.facebook = Utils.to_str(m['facebook'], '');
    obj.twitter = Utils.to_str(m['twitter'], '');
    obj.whatsapp = Utils.to_str(m['whatsapp'], '');
    obj.linkedin = Utils.to_str(m['linkedin'], '');
    obj.website = Utils.to_str(m['website'], '');
    obj.other_link = Utils.to_str(m['other_link'], '');
    obj.cv = Utils.to_str(m['cv'], '');
    obj.language = Utils.to_str(m['language'], '');
    obj.about = Utils.to_str(m['about'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.remember_token = Utils.to_str(m['remember_token'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.campus_id = Utils.to_str(m['campus_id'], '');
    obj.campus_text = Utils.to_str(m['campus_text'], '');
    obj.complete_profile = Utils.to_str(m['complete_profile'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.dob = Utils.to_str(m['dob'], '');
    obj.intro = Utils.to_str(m['intro'], '');
    obj.business_name = Utils.to_str(m['business_name'], '');
    obj.business_license_number =
        Utils.to_str(m['business_license_number'], '');
    obj.business_license_issue_authority =
        Utils.to_str(m['business_license_issue_authority'], '');
    obj.business_license_issue_date =
        Utils.to_str(m['business_license_issue_date'], '');
    obj.business_license_validity =
        Utils.to_str(m['business_license_validity'], '');
    obj.business_address = Utils.to_str(m['business_address'], '');
    obj.business_phone_number = Utils.to_str(m['business_phone_number'], '');
    obj.business_whatsapp = Utils.to_str(m['business_whatsapp'], '');
    obj.business_email = Utils.to_str(m['business_email'], '');
    obj.business_logo = Utils.to_str(m['business_logo'], '');
    obj.business_cover_photo = Utils.to_str(m['business_cover_photo'], '');
    obj.business_cover_details = Utils.to_str(m['business_cover_details'], '');
    obj.status = Utils.to_str(m['status'], '');

    return obj;
  }

  static Future<List<LoggedInUserModel>> getLocalData(
      {String where = "1"}) async {
    List<LoggedInUserModel> data = [];
    if (!(await LoggedInUserModel.initTable())) {
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
      data.add(LoggedInUserModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<LoggedInUserModel>> get_items({String where = '1'}) async {
    List<LoggedInUserModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await LoggedInUserModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      LoggedInUserModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<LoggedInUserModel>> getOnlineItems() async {
    List<LoggedInUserModel> data = [];

    RespondModel resp = RespondModel(await Utils.http_get('users/me', {}));

    if (resp.code != 1) {
      return [];
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await LoggedInUserModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          LoggedInUserModel sub = LoggedInUserModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("failed to save because ${e.toString()}");
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
          print("faied to save to commit BRECASE == ${e.toString()}");
        }
      });
    }

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
      print("==>${e.toString()}");
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'first_name': first_name,
      'last_name': last_name,
      'reg_date': reg_date,
      'last_seen': last_seen,
      'email': email,
      'approved': approved,
      'profile_photo': profile_photo,
      'user_type': user_type,
      'sex': sex,
      'reg_number': reg_number,
      'country': country,
      'occupation': occupation,
      'profile_photo_large': profile_photo_large,
      'phone_number': phone_number,
      'location_lat': location_lat,
      'location_long': location_long,
      'facebook': facebook,
      'twitter': twitter,
      'whatsapp': whatsapp,
      'linkedin': linkedin,
      'website': website,
      'other_link': other_link,
      'cv': cv,
      'language': language,
      'about': about,
      'address': address,
      'created_at': created_at,
      'updated_at': updated_at,
      'remember_token': remember_token,
      'avatar': avatar,
      'name': name,
      'campus_id': campus_id,
      'campus_text': campus_text,
      'complete_profile': complete_profile,
      'title': title,
      'dob': dob,
      'intro': intro,
      'business_name': business_name,
      'business_license_number': business_license_number,
      'business_license_issue_authority': business_license_issue_authority,
      'business_license_issue_date': business_license_issue_date,
      'business_license_validity': business_license_validity,
      'business_address': business_address,
      'business_phone_number': business_phone_number,
      'business_whatsapp': business_whatsapp,
      'business_email': business_email,
      'business_logo': business_logo,
      'business_cover_photo': business_cover_photo,
      'business_cover_details': business_cover_details,
      'status': status,
    };
  }

  bool isVendor() {
    return user_type.toLowerCase() == 'Vendor'.toLowerCase();
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY"
        ",username TEXT"
        ",password TEXT"
        ",first_name TEXT"
        ",last_name TEXT"
        ",reg_date TEXT"
        ",last_seen TEXT"
        ",email TEXT"
        ",approved TEXT"
        ",profile_photo TEXT"
        ",user_type TEXT"
        ",sex TEXT"
        ",reg_number TEXT"
        ",country TEXT"
        ",occupation TEXT"
        ",profile_photo_large TEXT"
        ",phone_number TEXT"
        ",location_lat TEXT"
        ",location_long TEXT"
        ",facebook TEXT"
        ",twitter TEXT"
        ",whatsapp TEXT"
        ",linkedin TEXT"
        ",website TEXT"
        ",other_link TEXT"
        ",cv TEXT"
        ",language TEXT"
        ",about TEXT"
        ",address TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",remember_token TEXT"
        ",avatar TEXT"
        ",name TEXT"
        ",campus_id TEXT"
        ",campus_text TEXT"
        ",complete_profile TEXT"
        ",title TEXT"
        ",dob TEXT"
        ",intro TEXT"
        ",business_name TEXT"
        ",business_license_number TEXT"
        ",business_license_issue_authority TEXT"
        ",business_license_issue_date TEXT"
        ",business_license_validity TEXT"
        ",business_address TEXT"
        ",business_phone_number TEXT"
        ",business_whatsapp TEXT"
        ",business_email TEXT"
        ",business_logo TEXT"
        ",business_cover_photo TEXT"
        ",business_cover_details TEXT"
        ",status TEXT"
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
    if (!(await LoggedInUserModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(LoggedInUserModel.tableName);
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
      print("1.. ${e.toString()}");
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }
}
