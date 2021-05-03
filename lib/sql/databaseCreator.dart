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
    await _createPasswordTable(db);
    await _createUnusedTable(db);
  }

  Future<void> _createPasswordTable(Database db) async {
    final query = '''
      CREATE TABLE ${Passwords.tableName} 
      (
        ${Passwords.websiteNameField} TEXT PRIMARY KEY,
        ${Passwords.imageGroupField} INT NOT NULL,
        ${Passwords.usernameField} TEXT NOT NULL,
        ${Passwords.passwordField} TEXT NOT NULL,
        ${Passwords.isFavoriteField} BIT NOT NULL
      );
      ''';
    await db.execute(query);
  }

  Future<void> _createUnusedTable(Database db) async {
    final query = '''
      CREATE TABLE ${Unused.tableName} 
      (
        ${Unused.websiteNameField} TEXT PRIMARY KEY,
        ${Unused.imageGroupField} INT NOT NULL
      );
      ''';
    await db.execute(query);
  }
}
