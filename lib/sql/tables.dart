import 'package:password_manager/sql/databaseCreator.dart';
import '../websites.dart';

class WebsitesTable {
  final db = DatabaseCreator.db;
  static const tableName = "Websites";
  static const primaryKeyField = "rowid";
  static const websiteNameField = "websiteName";
  static const imageGroupField = "imageGroup";
  static const foreignKeyQuery =
      "SELECT ${WebsitesTable.primaryKeyField} FROM ${WebsitesTable.tableName} WHERE ${WebsitesTable.websiteNameField}";

  Future<void> addAllGlobalWebsites(List<UnusedWebsite> websiteList) async {
    websiteList.forEach((website) async {
      await _addWebsite(website);
    });
  }

  Future<void> _addWebsite(UnusedWebsite website) async {
    final sql = '''
      INSERT INTO $tableName
        (
          $websiteNameField,
          $imageGroupField
        )
        VALUES
        (
          '${website.websiteName}',
          '${website.imageGroup}'
        );
    ''';
    await db.rawInsert(sql);
  }
}

abstract class Table<T extends Website> {
  final db = DatabaseCreator.db;
  static String tableName;
  static String foreignKeyField = "w_id";

  Table(tableName) {
    Table.tableName = tableName;
  }

  Future<void> addWebsite(T website);

  Future<void> deleteWebsite(T website) async {
    final sql = '''
      DELETE FROM $tableName
      WHERE $foreignKeyField in
        (
          SELECT ${WebsitesTable.primaryKeyField}
          FROM ${WebsitesTable.tableName}
          WHERE ${WebsitesTable.websiteNameField} = '${website.websiteName}'
        );
    ''';
    await db.rawDelete(sql);
  }

  Future<List<T>> getWebsiteList();

  Future<List<Map<String, Object>>> getAllWebsites() async {
    final sql = '''
      SELECT * FROM $tableName, ${WebsitesTable.tableName}
      WHERE ${Table.foreignKeyField} 
        = ${WebsitesTable.tableName}.${WebsitesTable.primaryKeyField};
    ''';
    List<Map<String, Object>> queryResult = await db.rawQuery(sql);
    return queryResult;
  }
}

class Passwords extends Table<UserWebsite> {
  static const tableName = "Passwords";
  static const usernameField = "username";
  static const passwordField = "password";
  static const isFavoriteField = "isFavorite";

  Passwords() : super(tableName);

  Future<void> addWebsite(UserWebsite website) async {
    final sql = '''
      INSERT INTO $tableName
        (
          ${Table.foreignKeyField},
          $usernameField,
          $passwordField,
          $isFavoriteField
        )
        VALUES
        (
          (${WebsitesTable.foreignKeyQuery} = '${website.websiteName}'),
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
      WHERE ${Table.foreignKeyField} in (${WebsitesTable.foreignKeyQuery} = '${website.websiteName}');
    ''';
    await db.rawUpdate(sql);
  }
}

class Unused extends Table<UnusedWebsite> {
  static const tableName = "Unused";

  Unused() : super(tableName);

  @override
  Future<void> addWebsite(UnusedWebsite website) async {
    final sql = '''
      INSERT INTO $tableName
        (
          ${Table.foreignKeyField}
        )
        VALUES
        (
          (${WebsitesTable.foreignKeyQuery} = '${website.websiteName}')
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
