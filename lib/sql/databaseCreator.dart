import 'dart:io';
import 'package:path/path.dart';
import 'package:password_manager/sql/tables.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCreator {
  static Database db;

  static const databaseName = "websites";

  Future<void> initDatabase() async {
    final path = await this.getDatabasePath();
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    if (!await Directory(dirname(path)).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }
    await deleteDatabase(path);
    return path;
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createWebsitesTable(db);
    await _createPasswordsTable(db);
    await _createUnusedTable(db);
  }

  Future<void> _createWebsitesTable(Database db) async {
    final sql = '''
      CREATE TABLE ${WebsitesTable.tableName}
      (
        ${WebsitesTable.websiteNameField} TEXT NOT NULL,
        ${WebsitesTable.imageGroupField} INT NOT NULL
      );
    ''';
    await db.execute(sql);
  }

  Future<void> _createPasswordsTable(Database db) async {
    final sql = '''
      CREATE TABLE ${Passwords.tableName}
      (
        ${Table.foreignKeyField} INT NOT NULL, 
        ${Passwords.usernameField} TEXT NOT NULL,
        ${Passwords.passwordField} TEXT NOT NULL,
        ${Passwords.isFavoriteField} BIT NOT NULL,
        FOREIGN KEY (${Table.foreignKeyField}) REFERENCES ${WebsitesTable.tableName}(${WebsitesTable.primaryKeyField})
      );
    ''';
    await db.execute(sql);
  }

  Future<void> _createUnusedTable(Database db) async {
    final sql = '''
      CREATE TABLE ${Unused.tableName} 
      (
        ${Table.foreignKeyField} INT NOT NULL,
        FOREIGN KEY (${Table.foreignKeyField}) REFERENCES ${WebsitesTable.tableName}(${WebsitesTable.primaryKeyField})
      );
    ''';
    await db.execute(sql);
  }
}
