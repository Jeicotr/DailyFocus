import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/user.dart';

/// Clase auxiliar para gestionar operaciones de base de datos SQLite.
/// Implementa el patrón Singleton para asegurar una única instancia.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Nombre de la base de datos
  static const String _databaseName = "daily_focus.db";

  // Versión de la base de datos (incrementar cuando se modifique el esquema)
  static const int _databaseVersion = 1;

  // Nombre de la tabla de usuarios
  static const String tableUsers = 'users';

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

  /// Cierra la conexión a la base de datos si está abierta.
  Future<void> closeDatabase() async {
    if (_database != null) {
      print('Cerrando conexión a la base de datos...');
      await _database!.close();
      _database = null;
      print('Conexión a la base de datos cerrada');
    }
  }

  /// Inicializa la base de datos, creando el archivo y las tablas necesarias.
  Future<Database> _initDatabase() async {
    try {
      // Obtiene la ruta donde se almacenará la base de datos
      print('Intentando obtener el directorio de documentos...');
      final documentsDirectory = await getApplicationDocumentsDirectory();
      print('Directorio de documentos obtenido: ${documentsDirectory.path}');
      final path = join(documentsDirectory.path, _databaseName);
      print('Ruta de la base de datos: $path');

      // Abre la base de datos, creándola si no existe
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
      );
    } catch (e) {
      print('Error al inicializar la base de datos: $e');
      // Rethrow para que el error sea manejado por el llamador
      rethrow;
    }
  }

  /// Crea las tablas de la base de datos cuando se inicializa por primera vez.
  Future<void> _onCreate(Database db, int version) async {
    // Crea la tabla de usuarios
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  /// Elimina completamente la base de datos y la reinicializa.
  /// Útil para depuración y cuando se necesita un estado limpio.
  Future<bool> resetDatabase() async {
    try {
      print('Iniciando reseteo completo de la base de datos...');

      // Cerrar la conexión actual si existe
      await closeDatabase();

      // Obtener la ruta de la base de datos
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);

      // Verificar si el archivo existe
      final databaseExists = await databaseFactory.databaseExists(path);
      if (databaseExists) {
        print('Eliminando archivo de base de datos: $path');
        // Eliminar el archivo de la base de datos
        await deleteDatabase(path);
        print('Archivo de base de datos eliminado');
      } else {
        print(
          'El archivo de base de datos no existe, no es necesario eliminarlo',
        );
      }

      // Reinicializar la base de datos

      _database = null;

      //print('Base de datos reinicializada correctamente');

      return true;
    } catch (e) {
      //print('Error al resetear la base de datos: $e');
      return false;
    }
  }

  /// Inserta un nuevo usuario en la base de datos.
  /// Retorna el ID del usuario insertado, o -1 si el email ya existe.
  Future<int> insertUser(User user) async {
    try {
      final db = await database;

      // Normalizar el email del usuario
      final normalizedEmail = user.email.trim().toLowerCase();
      print(
        'Intentando insertar usuario con email normalizado: $normalizedEmail',
      );

      // Crear una copia del usuario con el email normalizado
      final normalizedUser = user.copyWith(email: normalizedEmail);

      // Verificar si la tabla existe
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableUsers'",
      );
      if (tables.isEmpty) {
        print('La tabla $tableUsers no existe, creándola...');
        await _onCreate(db, _databaseVersion);
      }

      // Verificar directamente en la base de datos si el email existe
      final existingEmails = await db.rawQuery(
        "SELECT email FROM $tableUsers WHERE LOWER(email) = ?",
        [normalizedEmail],
      );

      if (existingEmails.isNotEmpty) {
        print('Email ya registrado (verificación directa): $normalizedEmail');
        return -1; // Email ya registrado
      }

      // Verifica si el email ya existe usando el método getUserByEmail
      final existingUser = await getUserByEmail(normalizedEmail);
      if (existingUser != null) {
        print('Email ya registrado (getUserByEmail): $normalizedEmail');
        return -1; // Email ya registrado
      }

      print('Email no encontrado, procediendo con la inserción');

      // Intentar insertar directamente y capturar errores de restricción UNIQUE
      try {
        // Eliminar el id si es null para que la base de datos lo genere automáticamente
        final userMap = normalizedUser.toMap();
        if (userMap['id'] == null) {
          userMap.remove('id');
        }

        final id = await db.insert(tableUsers, userMap);
        print('Usuario insertado con ID: $id');
        return id;
      } catch (e) {
        if (e.toString().contains('UNIQUE constraint failed')) {
          print('Error de restricción UNIQUE al insertar: $e');
          return -1; // Email ya registrado (detectado por la restricción UNIQUE)
        }
        rethrow;
      }
    } catch (e) {
      print('Error al insertar usuario: $e');
      return -1;
    }
  }

  /// Busca un usuario por su email.
  /// Retorna null si no se encuentra.
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await database;
      print('Buscando usuario con email: $email');

      // Verificar si la tabla existe
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableUsers'",
      );
      if (tables.isEmpty) {
        print('La tabla $tableUsers no existe');
        return null;
      }

      final List<Map<String, dynamic>> maps = await db.query(
        tableUsers,
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()], // Normalizar el email
      );

      print('Resultados encontrados: ${maps.length}');
      if (maps.isEmpty) return null;

      print('Usuario encontrado: ${maps.first}');
      return User.fromMap(maps.first);
    } catch (e) {
      print('Error en getUserByEmail: $e');
      return null;
    }
  }

  /// Verifica las credenciales de un usuario para el inicio de sesión.
  /// Retorna el usuario si las credenciales son correctas, null en caso contrario.
  Future<User?> loginUser(String email, String password) async {
    try {
      final db = await database;

      // Normalizar el email
      final normalizedEmail = email.trim().toLowerCase();
      print(
        'Intentando iniciar sesión con email normalizado: $normalizedEmail',
      );

      final List<Map<String, dynamic>> maps = await db.query(
        tableUsers,
        where: 'email = ? AND password = ?',
        whereArgs: [normalizedEmail, password],
      );

      print('Resultados de login encontrados: ${maps.length}');
      if (maps.isEmpty) {
        print('Credenciales incorrectas para email: $normalizedEmail');
        return null;
      }

      print('Usuario autenticado: ${maps.first['name']}');
      return User.fromMap(maps.first);
    } catch (e) {
      print('Error en loginUser: $e');
      return null;
    }
  }

  /// Actualiza los datos de un usuario existente.
  /// Retorna el número de filas afectadas.
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Elimina un usuario de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(tableUsers, where: 'id = ?', whereArgs: [id]);
  }

  /// Obtiene todos los usuarios de la base de datos.
  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(tableUsers);
      print('Total de usuarios en la base de datos: ${maps.length}');
      return List.generate(maps.length, (i) => User.fromMap(maps[i]));
    } catch (e) {
      print('Error al obtener todos los usuarios: $e');
      return [];
    }
  }

  /// Elimina todos los usuarios de la base de datos.
  /// Útil para depuración y pruebas.
  /// Retorna el número de filas afectadas.
  Future<int> deleteAllUsers() async {
    try {
      final db = await database;
      final count = await db.delete(tableUsers);
      print('Se eliminaron $count usuarios de la base de datos');
      return count;
    } catch (e) {
      print('Error al eliminar todos los usuarios: $e');
      return 0;
    }
  }

  /// Verifica si la base de datos está inicializada correctamente.
  /// Retorna true si la tabla de usuarios existe, false en caso contrario.
  Future<bool> isDatabaseInitialized() async {
    try {
      final db = await database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableUsers'",
      );
      final isInitialized = tables.isNotEmpty;
      print('Base de datos inicializada: $isInitialized');
      return isInitialized;
    } catch (e) {
      print('Error al verificar la inicialización de la base de datos: $e');
      return false;
    }
  }
}
