import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'tables/users.dart';
import 'tables/activities.dart';

/// Clase auxiliar para gestionar la base de datos SQLite.
/// Proporciona métodos para inicializar la base de datos y realizar operaciones CRUD.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Nombre de la base de datos
  static const String _databaseName = 'daily_focus.db';

  // Versión de la base de datos
  static const int _databaseVersion = 1;

  // Constructor factory que devuelve la instancia singleton
  factory DatabaseHelper() {
    return _instance;
  }

  // Constructor privado para el patrón Singleton
  DatabaseHelper._internal();

  /// Obtiene la instancia de la base de datos, creándola si no existe.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos.
  Future<Database> _initDatabase() async {
    // Obtener el directorio de documentos de la aplicación
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    print('Inicializando base de datos SQLite en: $path');

    // Abrir la base de datos, creándola si no existe
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Crea las tablas de la base de datos.
  Future<void> _onCreate(Database db, int version) async {
    print('Creando tablas de la base de datos SQLite...');

    // Crear tabla de usuarios
    await db.execute(Users.createTable());

    // Crear tabla de actividades
    await db.execute(Activities.createTable());

    print('Tablas creadas correctamente');
  }

  /// Cierra la conexión a la base de datos si está abierta.
  Future<void> close() async {
    if (_database != null) {
      print('Cerrando conexión a la base de datos SQLite...');
      await _database!.close();
      _database = null;
      print('Conexión a la base de datos SQLite cerrada');
    }
  }

  /// Inserta un nuevo usuario en la base de datos.
  /// Retorna el ID del usuario insertado.
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(Users.tableName, user);
  }

  /// Busca un usuario por su email.
  /// Retorna null si no se encuentra.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final normalizedEmail = email.trim().toLowerCase();

    final List<Map<String, dynamic>> result = await db.query(
      Users.tableName,
      where: '${Users.columnEmail} = ?',
      whereArgs: [normalizedEmail],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  /// Verifica las credenciales de un usuario para el inicio de sesión.
  /// Retorna el usuario si las credenciales son correctas, null en caso contrario.
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final normalizedEmail = email.trim().toLowerCase();

    final List<Map<String, dynamic>> result = await db.query(
      Users.tableName,
      where: '${Users.columnEmail} = ? AND ${Users.columnPassword} = ?',
      whereArgs: [normalizedEmail, password],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  /// Obtiene todos los usuarios de la base de datos.
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query(Users.tableName);
  }

  /// Actualiza los datos de un usuario existente.
  /// Retorna el número de filas afectadas.
  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      Users.tableName,
      user,
      where: '${Users.columnId} = ?',
      whereArgs: [user[Users.columnId]],
    );
  }

  /// Elimina un usuario de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      Users.tableName,
      where: '${Users.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Elimina todos los usuarios de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteAllUsers() async {
    final db = await database;
    return await db.delete(Users.tableName);
  }

  /// Inserta una nueva actividad en la base de datos.
  /// Retorna el ID de la actividad insertada.
  Future<int> insertActivity(Map<String, dynamic> activity) async {
    final db = await database;
    return await db.insert(Activities.tableName, activity);
  }

  /// Obtiene todas las actividades de la base de datos.
  Future<List<Map<String, dynamic>>> getAllActivities() async {
    final db = await database;
    return await db.query(Activities.tableName);
  }

  /// Actualiza los datos de una actividad existente.
  /// Retorna el número de filas afectadas.
  Future<int> updateActivity(Map<String, dynamic> activity) async {
    final db = await database;
    return await db.update(
      Activities.tableName,
      activity,
      where: '${Activities.columnId} = ?',
      whereArgs: [activity[Activities.columnId]],
    );
  }

  /// Elimina una actividad de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(
      Activities.tableName,
      where: '${Activities.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Elimina todas las actividades de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteAllActivities() async {
    final db = await database;
    return await db.delete(Activities.tableName);
  }

  /// Elimina completamente la base de datos y la reinicializa.
  Future<void> resetDatabase() async {
    print('Iniciando reseteo completo de la base de datos SQLite...');

    // Cerrar la conexión actual si existe
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Obtener la ruta de la base de datos
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    // Eliminar el archivo de la base de datos si existe
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('Archivo de base de datos eliminado');
    }

    // Reinicializar la base de datos
    _database = await _initDatabase();
    print('Base de datos SQLite reinicializada correctamente');
  }
}
