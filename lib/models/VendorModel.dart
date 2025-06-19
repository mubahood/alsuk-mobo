import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class VendorModel {
  static String end_point = "vendors";
  static String tableName = "vendors";
  String about = "";
  String address = "";
  String approved = "";
  String avatar = "";
  String business_address = "";
  String business_cover_details = "";
  String business_cover_photo = "";
  String business_email = "";
  String business_license_issue_authority = "";
  String business_license_issue_date = "";
  String business_license_number = "";
  String business_license_validity = "";
  String business_logo = "";
  String business_name = "";
  String business_phone_number = "";
  String business_whatsapp = "";
  String campus_id = "";
  String campus_text = "";
  String complete_profile = "";
  String country = "";
  String created_at = "";
  String cv = "";
  String dob = "";
  String email = "";
  String facebook = "";
  String first_name = "";
  int id = 0;
  String intro = "";
  String language = "";
  String last_name = "";
  String last_seen = "";
  String linkedin = "";
  String location_lat = "";
  String location_long = "";
  String name = "";
  String nin = "";
  String occupation = "";
  String other_link = "";
  String password = "";
  String phone_number = "";
  String profile_photo = "";
  String profile_photo_large = "";
  String reg_date = "";
  String reg_number = "";
  String remember_token = "";
  String sex = "";
  String status = "";
  String title = "";
  String twitter = "";
  String updated_at = "";
  String user_type = "";
  String username = "";
  String website = "";
  String whatsapp = "";

  static fromJson(dynamic m) {
    VendorModel obj = VendorModel();
    if (m == null) {
      return obj;
    }

    obj.about = Utils.to_str(m['about'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.approved = Utils.to_str(m['approved'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');
    obj.business_address = Utils.to_str(m['business_address'], '');
    obj.business_cover_details = Utils.to_str(m['business_cover_details'], '');
    obj.business_cover_photo = Utils.to_str(m['business_cover_photo'], '');
    obj.business_email = Utils.to_str(m['business_email'], '');
    obj.business_license_issue_authority =
        Utils.to_str(m['business_license_issue_authority'], '');
    obj.business_license_issue_date =
        Utils.to_str(m['business_license_issue_date'], '');
    obj.business_license_number =
        Utils.to_str(m['business_license_number'], '');
    obj.business_license_validity =
        Utils.to_str(m['business_license_validity'], '');
    obj.business_logo = Utils.to_str(m['business_logo'], '');
    obj.business_name = Utils.to_str(m['business_name'], '');
    obj.business_phone_number = Utils.to_str(m['business_phone_number'], '');
    obj.business_whatsapp = Utils.to_str(m['business_whatsapp'], '');
    obj.campus_id = Utils.to_str(m['campus_id'], '');
    obj.campus_text = Utils.to_str(m['campus_text'], '');
    obj.complete_profile = Utils.to_str(m['complete_profile'], '');
    obj.country = Utils.to_str(m['country'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.cv = Utils.to_str(m['cv'], '');
    obj.dob = Utils.to_str(m['dob'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.facebook = Utils.to_str(m['facebook'], '');
    obj.first_name = Utils.to_str(m['first_name'], '');
    obj.id = Utils.int_parse(m['id']);
    obj.intro = Utils.to_str(m['intro'], '');
    obj.language = Utils.to_str(m['language'], '');
    obj.last_name = Utils.to_str(m['last_name'], '');
    obj.last_seen = Utils.to_str(m['last_seen'], '');
    obj.linkedin = Utils.to_str(m['linkedin'], '');
    obj.location_lat = Utils.to_str(m['location_lat'], '');
    obj.location_long = Utils.to_str(m['location_long'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.nin = Utils.to_str(m['nin'], '');
    obj.occupation = Utils.to_str(m['occupation'], '');
    obj.other_link = Utils.to_str(m['other_link'], '');
    obj.password = Utils.to_str(m['password'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.profile_photo = Utils.to_str(m['profile_photo'], '');
    obj.profile_photo_large = Utils.to_str(m['profile_photo_large'], '');
    obj.reg_date = Utils.to_str(m['reg_date'], '');
    obj.reg_number = Utils.to_str(m['reg_number'], '');
    obj.remember_token = Utils.to_str(m['remember_token'], '');
    obj.sex = Utils.to_str(m['sex'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.twitter = Utils.to_str(m['twitter'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.user_type = Utils.to_str(m['user_type'], '');
    obj.username = Utils.to_str(m['username'], '');
    obj.website = Utils.to_str(m['website'], '');
    obj.whatsapp = Utils.to_str(m['whatsapp'], '');

    return obj;
  }

  static Future<List<VendorModel>> getLocalData({String where = "1"}) async {
    List<VendorModel> data = [];
    if (!(await VendorModel.initTable())) {
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
      data.add(VendorModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<VendorModel>> get_items({String where = '1'}) async {
    List<VendorModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await VendorModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      VendorModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<VendorModel>> getOnlineItems() async {
    List<VendorModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(VendorModel.end_point, {}));

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
        await VendorModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          VendorModel sub = VendorModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("faied to save becaus ${e.toString()}");
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
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'about': about,
      'address': address,
      'approved': approved,
      'avatar': avatar,
      'business_address': business_address,
      'business_cover_details': business_cover_details,
      'business_cover_photo': business_cover_photo,
      'business_email': business_email,
      'business_license_issue_authority': business_license_issue_authority,
      'business_license_issue_date': business_license_issue_date,
      'business_license_number': business_license_number,
      'business_license_validity': business_license_validity,
      'business_logo': business_logo,
      'business_name': business_name,
      'business_phone_number': business_phone_number,
      'business_whatsapp': business_whatsapp,
      'campus_id': campus_id,
      'campus_text': campus_text,
      'complete_profile': complete_profile,
      'country': country,
      'created_at': created_at,
      'cv': cv,
      'dob': dob,
      'email': email,
      'facebook': facebook,
      'first_name': first_name,
      'id': id,
      'intro': intro,
      'language': language,
      'last_name': last_name,
      'last_seen': last_seen,
      'linkedin': linkedin,
      'location_lat': location_lat,
      'location_long': location_long,
      'name': name,
      'nin': nin,
      'occupation': occupation,
      'other_link': other_link,
      'password': password,
      'phone_number': phone_number,
      'profile_photo': profile_photo,
      'profile_photo_large': profile_photo_large,
      'reg_date': reg_date,
      'reg_number': reg_number,
      'remember_token': remember_token,
      'sex': sex,
      'status': status,
      'title': title,
      'twitter': twitter,
      'updated_at': updated_at,
      'user_type': user_type,
      'username': username,
      'website': website,
      'whatsapp': whatsapp,
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
        ",about TEXT"
        ",address TEXT"
        ",approved TEXT"
        ",avatar TEXT"
        ",business_address TEXT"
        ",business_cover_details TEXT"
        ",business_cover_photo TEXT"
        ",business_email TEXT"
        ",business_license_issue_authority TEXT"
        ",business_license_issue_date TEXT"
        ",business_license_number TEXT"
        ",business_license_validity TEXT"
        ",business_logo TEXT"
        ",business_name TEXT"
        ",business_phone_number TEXT"
        ",business_whatsapp TEXT"
        ",campus_id TEXT"
        ",campus_text TEXT"
        ",complete_profile TEXT"
        ",country TEXT"
        ",created_at TEXT"
        ",cv TEXT"
        ",dob TEXT"
        ",email TEXT"
        ",facebook TEXT"
        ",first_name TEXT"
        ",intro TEXT"
        ",language TEXT"
        ",last_name TEXT"
        ",last_seen TEXT"
        ",linkedin TEXT"
        ",location_lat TEXT"
        ",location_long TEXT"
        ",name TEXT"
        ",nin TEXT"
        ",occupation TEXT"
        ",other_link TEXT"
        ",password TEXT"
        ",phone_number TEXT"
        ",profile_photo TEXT"
        ",profile_photo_large TEXT"
        ",reg_date TEXT"
        ",reg_number TEXT"
        ",remember_token TEXT"
        ",sex TEXT"
        ",status TEXT"
        ",title TEXT"
        ",twitter TEXT"
        ",updated_at TEXT"
        ",user_type TEXT"
        ",username TEXT"
        ",website TEXT"
        ",whatsapp TEXT"
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
    if (!(await VendorModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(VendorModel.tableName);
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
}
