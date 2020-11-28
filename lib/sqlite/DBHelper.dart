import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'package:flutter_database/sqlite/estudiantes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ESTUDIANTES = 'Estudiantes';
  static const String ID = 'id';
  static const String NOMBRE = 'nombre';
  static const String NOTA1 = 'nota1';
  static const String NOTA2 = 'nota2';
  static const String NOTA3 = 'nota3';
  static const String NOTAFINAL = 'notaFinal';


  static const String DB_NAME = 'sdfsfff.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    log(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $ESTUDIANTES ($ID INTEGER PRIMARY KEY, $NOMBRE TEXT, $NOTA1 REAL, $NOTA2 REAL, $NOTA3 REAL, $NOTAFINAL REAL)");


  }

  Future<Estudiantes> save(Estudiantes estudiantes) async {
    var dbClient = await db;
    estudiantes.id = await dbClient.insert("Estudiantes", estudiantes.toMap());
    return estudiantes;
  }

  Future<List<Estudiantes>> getEstudiantes() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(ESTUDIANTES, columns: [ID, NOMBRE, NOTA1, NOTA2, NOTA3, NOTAFINAL]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Estudiantes> estudiantes = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        estudiantes.add(Estudiantes.fromMap(maps[i]));
      }
    }
    return estudiantes;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(ESTUDIANTES, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Estudiantes estudiantes) async {
    var dbClient = await db;
    return await dbClient.update(ESTUDIANTES, estudiantes.toMap(),
        where: '$ID = ?', whereArgs: [estudiantes.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}