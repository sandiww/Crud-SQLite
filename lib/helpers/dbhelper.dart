import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:crud_sqlite/models/contact.dart';
// get from pubspec.yml

//Class Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {

    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contact.db';

    //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //Create New Table By The Name Contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('contact', orderBy: 'name');
    return mapList;
  }

// Create Database
  Future<int> insert(Contact object) async {
    Database db = await this.database;
    int count = await db.insert('contact', object.toMap());
    return count;
  }
// Update Database
  Future<int> update(Contact object) async {
    Database db = await this.database;
    int count = await db.update('contact', object.toMap(),
        where: 'id=?',
        whereArgs: [object.id]);
    return count;
  }

// Delete Database
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('contact',
        where: 'id=?',
        whereArgs: [id]);
    return count;
  }

  Future<List<Contact>> getContactList() async {
    var contactMapList = await select();
    int count = contactMapList.length;
    List<Contact> contactList = List<Contact>();
    for (int i=0; i<count; i++) {
      contactList.add(Contact.fromMap(contactMapList[i]));
    }
    return contactList;
  }

}