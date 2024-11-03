import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;

  // Singleton
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    // Obtener la ruta de almacenamiento para la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print('Base de datos almacenada en: $path');

    // Crear la base de datos
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }

  // Método para insertar un nuevo Scan
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());

    // Imprimir el ID del registro insertado
    print('ID del último registro creado: $res');

    return res;
  }

  // Método para obtener un Scan por id
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;

    // Obtiene todos los registros (SELECT * from Scans)
    // final resAll = await db.query('Scans'); 
    // Obtiene el registro según un id
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  // Método para obtener todos los Scans
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  // Método para obtener todos los Scans por tipo
  Future<List<ScanModel>> getScansByTipo(String tipo) async {
    final db = await database;
    // Aquí lo hacemos por el método raw, para probarlo 
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo' 
    ''');
    
    return res.isNotEmpty 
    ? res.map((s) => ScanModel.fromJson(s)).toList()
    : [];
    }


    // Método para actualizar un Scan existente
    Future<int> updateScan(ScanModel nuevoScan) async {
      final db = await database;
    
    // Actualizar registro con el id específico
    final res = await db.update(
      'Scans', 
      nuevoScan.toJson(), 
      where: 'id = ?', 
      whereArgs: [nuevoScan.id],
    );
    
    return res; // Retorna el numero de filas afectadas 
}
  // Metodo para eliminar un Scan
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }
  
  // Metodo para eliminar todos los Scans
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }







}
