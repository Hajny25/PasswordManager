import 'dart:io';
import 'package:password_manager/sql/tables.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCreator {
  static Database db;
  static const databaseName = "websites.db";
  static const passwordsTable = "Passwords";
  // static const unusedTable = "Unused";
  // static const websiteNameField = "websiteName";
  // static const updateField = "update";
  // static const usernameField = "username";
  // static const passwordField = "password";
  // static const isFavoriteField = "isFavorite";

  Future<void> initDatabase() async {
    final path = await this.getDatabasePath();
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    final path = databasePath + databaseName;

    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    return path;
  }

  Future<void> _onCreate(Database db, int version) async {
    _createPasswordTable();
    _createUnusedTable();
  }

  Future<void> _createPasswordTable() async {
    final query = '''
      CREATE TABLE ${Passwords.tableName} 
      (
        ${Passwords.websiteNameField} TEXT PRIMARY KEY NOT NULL,
        ${Passwords.updateField} TEXT NOT NULL,
        ${Passwords.usernameField} TEXT NOT NULL,
        ${Passwords.passwordField} TEXT NOT NULL,
        ${Passwords.isFavoriteField} BIT NOT NULL,
      )''';
    db.execute(query);
  }

  Future<void> _createUnusedTable() async {
    final query = '''
      CREATE TABLE ${Unused.tableName} 
      (
        ${Unused.websiteNameField} TEXT PRIMARY KEY NOT NULL,
        ${Unused.updateField} TEXT NOT NULL,
      )''';
    db.execute(query);
  }
}
