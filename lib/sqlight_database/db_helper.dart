import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../modals/user_modal.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  // create database
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "user.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  // create tables
  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(uid INTEGER AUTO INCREMENT PRIMARY KEY, name TEXT, email TEXT)");

    //await db.execute(
    //  "CREATE TABLE Appointment(appointment_id INTEGER AUTO INCREMENT PRIMARY KEY, name TEXT, email TEXT, time TEXT)");

    // note that Im inserting password as plain text. When you implement please store it as a hash for security purposes.
  }

  // insert user to db when login
  Future<int?> saveUser(User user) async {
    Database? dbClient = await db;
    int? res = await dbClient?.insert("User", user.toMap());
    return res;
  }

  // retrieve user from db
  Future<List<User?>> getUser() async {
    var dbClient = await db;
    List<User?> users = [];
    List<Map<dynamic, dynamic>>? list =
        await dbClient?.rawQuery('SELECT * FROM User');
    if (list?.isNotEmpty ?? false) {
      list?.forEach((element) {
        users.add(User.fromJson(element));
      });
      return users;
    }
    return users;
  }

  Future<User?> getCurrentUser() async {
    var dbClient = await db;
    List<Map<dynamic, dynamic>>? list =
        await dbClient?.rawQuery('SELECT * FROM User');
    if (list?.isNotEmpty ?? false) {
      return User.fromJson(
          list?.elementAt(0) ?? {'name': 'no name', 'email': 'no email'});
    }
    return null;
  }

  //delete use when logout
  Future<int?> deleteUser(String name) async {
    var dbClient = await db;
    int? res = await dbClient?.delete("User",where: 'name = ?',whereArgs: [name]);
    return res;
  }

}
