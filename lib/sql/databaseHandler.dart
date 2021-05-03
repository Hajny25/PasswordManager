import 'package:password_manager/Firebase/database.dart';
import '../websites.dart';
import 'databaseCreator.dart';
import 'tables.dart';

class DatabaseHandler {
  static Future<void> setupDatabase() async {
    await DatabaseCreator().initDatabase();
    List<UnusedWebsite> websiteList = await getGlobalWebsites();
    await Unused().addAllGlobalWebsites(websiteList);
  }

  static Future<List<UserWebsite>> getUsedWebsites() async {
    List<UserWebsite> websiteList = await Passwords().getWebsiteList();
    return websiteList;
  }

  static Future<List<UnusedWebsite>> getUnusedWebsites() async {
    List<UnusedWebsite> websiteList = await Unused().getWebsiteList();
    return websiteList;
  }

  static Future<void> addPasswordEntry(UnusedWebsite unusedWebsite,
      UserWebsite userWebsite) async {
    await Unused().deleteWebsite(unusedWebsite);
    await Passwords().addWebsite(userWebsite);
  }

  static Future<void> deletePasswordEntry(UserWebsite userWebsite) async {
    await Passwords().deleteWebsite(userWebsite);
    UnusedWebsite unusedWebsite = UnusedWebsite.fromUserWebsite(userWebsite);
    await Unused().addWebsite(unusedWebsite);
  }

  static Future<void> updateFavorite(UserWebsite userWebsite) async {
    Passwords().updateFavoriteField(userWebsite);
  }
}
