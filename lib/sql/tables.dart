import 'package:password_manager/sql/databaseCreator.dart';
import '../websites.dart';

abstract class WebsiteTable<T extends Website> {
  final db = DatabaseCreator.db;
  static String tableName;
  static String websiteNameField;

  WebsiteTable(tableName, websiteNameField) {
    WebsiteTable.tableName = tableName;
    WebsiteTable.websiteNameField = websiteNameField;
  }

  Future<void> addWebsite(T website);

  Future<void> deleteWebsite(T website) async {
    final sql = '''
      DELETE FROM $tableName
      WHERE $websiteNameField = '${website.websiteName}';
    ''';
    await db.rawDelete(sql);
  }

  Future<List<T>> getWebsiteList();

  Future<List<Map<String, Object>>> getAllWebsites() async {
    final sql = '''
      SELECT * FROM $tableName;
    ''';
    List<Map<String, Object>> queryResult = await db.rawQuery(sql);
    return queryResult;
  }
}

class Passwords extends WebsiteTable<UserWebsite> {
  static const tableName = "Passwords";
  static const websiteNameField = "websiteName";
  static const imageGroupField = "imageGroup";
  static const usernameField = "username";
  static const passwordField = "password";
  static const isFavoriteField = "isFavorite";

  Passwords() : super(tableName, websiteNameField);

  Future<void> addWebsite(UserWebsite website) async {
    final sql = '''
      INSERT INTO $tableName
        (
          $websiteNameField,
          $imageGroupField,
          $usernameField,
          $passwordField,
          $isFavoriteField
        )
        VALUES
        (
          '${website.websiteName}',
          ${website.imageGroup},
          '${website.username}',
          '${website.password}',
          ${website.isFavorite ? 1 : 0}
        );
    ''';
    await db.rawInsert(sql);
  }

  @override
  Future<List<UserWebsite>> getWebsiteList() async {
    List<UserWebsite> websiteList = [];
    List<Map<String, Object>> queryResult = await getAllWebsites();
    queryResult.forEach((map) {
      websiteList.add(UserWebsite.fromMap(map));
    });
    return websiteList;
  }

  Future<void> updateFavoriteField(UserWebsite website) async {
    final sql = '''
      UPDATE $tableName
      SET $isFavoriteField = ${website.isFavorite ? 1 : 0}
      WHERE $websiteNameField = '{$website.websiteName}';
    ''';
    await db.rawUpdate(sql);
  }
}

class Unused extends WebsiteTable<UnusedWebsite> {
  static const tableName = "Unused";
  static const websiteNameField = "websiteName";
  static const imageGroupField = "imageGroup";

  Unused() : super(tableName, websiteNameField);

  @override
  Future<void> addWebsite(UnusedWebsite website) async {
    final sql = '''
      INSERT INTO $tableName
        (
          $websiteNameField,
          $imageGroupField
        )
        VALUES
        (
          '${website.websiteName}',
          ${website.imageGroup}
        );
    ''';
    await db.rawInsert(sql);
  }

  Future<void> addAllGlobalWebsites(List<UnusedWebsite> websiteList) async {
    websiteList.forEach((website) async {
      await addWebsite(website);
    });
  }

  @override
  Future<List<UnusedWebsite>> getWebsiteList() async {
    List<UnusedWebsite> websiteList = [];
    List<Map<String, Object>> queryResult = await getAllWebsites();
    queryResult.forEach((map) {
      websiteList.add(UnusedWebsite.fromMap(map));
    });
    return websiteList;
  }
}
