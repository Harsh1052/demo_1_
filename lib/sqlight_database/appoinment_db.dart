import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../modals/user_modal.dart';

class DatabaseHelper1 {
  static final DatabaseHelper1 _instance = DatabaseHelper1.internal();

  factory DatabaseHelper1() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper1.internal();

  // create database
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "appointment.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  // create tables
  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Appointment(uid INTEGER AUTO INCREMENT PRIMARY KEY, name TEXT, email TEXT, created_by TEXT, time TEXT)");

    //await db.execute(
    //  "CREATE TABLE Appointment(appointment_id INTEGER AUTO INCREMENT PRIMARY KEY, name TEXT, email TEXT, time TEXT)");


    // note that Im inserting password as plain text. When you implement please store it as a hash for security purposes.
  }



  Future<List<Appointment?>> getAppointment(String username) async {

    var dbClient = await db;
    List<Appointment?> appointments = [];
    List<Map<dynamic, dynamic>>? list = await dbClient?.rawQuery('SELECT * FROM Appointment WHERE created_by=?',[username]);


    if (list?.isNotEmpty??false) {
      list?.forEach((element) {

        appointments.add(Appointment.fromJson(element));

      });
      return appointments;
    }
    return appointments;
  }

  Future<int?> addAppointment(Appointment appointment) async {
    Database? dbClient = await db;
    int? res = await dbClient?.insert("Appointment", appointment.toMap());
    return res;
  }

  // check if the user logged in when app launch or any other place


}