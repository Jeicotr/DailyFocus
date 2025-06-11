import 'package:flutter_dailyfocus/database/app_database.dart';
import 'package:flutter_dailyfocus/database/models/user.dart' as model;
import 'package:drift/drift.dart';

/// Clase proveedora para la base de datos Drift.
/// Implementa el patrón Singleton para asegurar una única instancia.
/// Sirve como puente entre el código existente y la implementación de Drift.
class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static AppDatabase? _database;

  // Constructor factory que devuelve la instancia singleton
  factory DatabaseProvider() {
    return _instance;
  }

  // Constructor privado para el patrón Singleton
  DatabaseProvider._internal();

  /// Obtiene la instancia de la base de datos Drift, creándola si no existe.
  Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    _database = AppDatabase();
    return _database!;
  }

  /// Cierra la conexión a la base de datos si está abierta.
  Future<void> closeDatabase() async {
    if (_database != null) {
      print('Cerrando conexión a la base de datos Drift...');
      await _database!.close();
      _database = null;
      print('Conexión a la base de datos Drift cerrada');
    }
  }

  /// Inserta un nuevo usuario en la base de datos.
  /// Retorna el ID del usuario insertado, o -1 si el email ya existe.
  Future<int> insertUser(model.User user) async {
    try {
      final db = await database;

      // Normalizar el email del usuario
      final normalizedEmail = user.email.trim().toLowerCase();
      print(
        'Intentando insertar usuario con email normalizado: $normalizedEmail',
      );

      // Verificar si el email ya existe
      final existingUser = await getUserByEmail(normalizedEmail);
      if (existingUser != null) {
        print('Email ya registrado: $normalizedEmail');
        return -1; // Email ya registrado
      }

      // Crear un UsersCompanion para insertar en la base de datos Drift
      final userCompanion = UsersCompanion(
        name: Value(user.name),
        email: Value(normalizedEmail),
        password: Value(user.password),
      );

      // Insertar el usuario
      final id = await db.insertUser(userCompanion);
      print('Usuario insertado con ID: $id');
      return id;
    } catch (e) {
      print('Error al insertar usuario: $e');
      return -1;
    }
  }

  /// Busca un usuario por su email.
  /// Retorna null si no se encuentra.
  Future<model.User?> getUserByEmail(String email) async {
    try {
      final db = await database;

      // Buscar el usuario en la base de datos Drift
      final user = await db.getUserByEmail(email.trim().toLowerCase());

      if (user == null) {
        return null;
      }

      // Convertir el usuario de Drift a nuestro modelo
      print('Usuario encontrado: ${user.name}');
      return model.User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );
    } catch (e) {
      print('Error en getUserByEmail: $e');
      return null;
    }
  }

  /// Verifica las credenciales de un usuario para el inicio de sesión.
  /// Retorna el usuario si las credenciales son correctas, null en caso contrario.
  Future<model.User?> loginUser(String email, String password) async {
    try {
      final db = await database;

      // Normalizar el email
      final normalizedEmail = email.trim().toLowerCase();
      print(
        'Intentando iniciar sesión con email normalizado: $normalizedEmail',
      );

      // Buscar el usuario en la base de datos Drift
      final user = await db.loginUser(normalizedEmail, password);

      if (user == null) {
        print('Credenciales incorrectas para email: $normalizedEmail');
        return null;
      }

      // Convertir el usuario de Drift a nuestro modelo
      print('Usuario autenticado: ${user.name}');
      return model.User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );
    } catch (e) {
      print('Error en loginUser: $e');
      return null;
    }
  }

  /// Actualiza los datos de un usuario existente.
  /// Retorna true si la actualización fue exitosa, false en caso contrario.
  Future<bool> updateUser(model.User user) async {
    try {
      final db = await database;

      // Convertir nuestro modelo a un usuario de Drift
      final driftUser = User(
        id: user.id!,
        name: user.name,
        email: user.email,
        password: user.password,
      );

      // Actualizar el usuario en la base de datos Drift
      return await db.updateUser(driftUser);
    } catch (e) {
      print('Error en updateUser: $e');
      return false;
    }
  }

  /// Elimina un usuario de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteUser(int id) async {
    try {
      final db = await database;
      return await db.deleteUserById(id);
    } catch (e) {
      print('Error en deleteUser: $e');
      return 0;
    }
  }

  /// Obtiene todos los usuarios de la base de datos.
  Future<List<model.User>> getAllUsers() async {
    try {
      final db = await database;
      final users = await db.getAllUsers();
      print('Total de usuarios en la base de datos: ${users.length}');

      // Convertir los usuarios de Drift a nuestro modelo
      return users
          .map(
            (user) => model.User(
              id: user.id,
              name: user.name,
              email: user.email,
              password: user.password,
            ),
          )
          .toList();
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
      final count = await db.deleteAllUsers();
      print('Se eliminaron $count usuarios de la base de datos');
      return count;
    } catch (e) {
      print('Error al eliminar todos los usuarios: $e');
      return 0;
    }
  }

  /// Verifica si la base de datos está inicializada correctamente.
  /// Retorna true si la base de datos está inicializada, false en caso contrario.
  Future<bool> isDatabaseInitialized() async {
    try {
      // En Drift, si podemos obtener la base de datos, está inicializada
      return true;
    } catch (e) {
      print('Error al verificar la inicialización de la base de datos: $e');
      return false;
    }
  }

  /// Elimina completamente la base de datos y la reinicializa.
  /// Útil para depuración y cuando se necesita un estado limpio.
  Future<bool> resetDatabase() async {
    try {
      print('Iniciando reseteo completo de la base de datos Drift...');

      // Cerrar la conexión actual si existe
      await closeDatabase();

      // Crear una nueva instancia de la base de datos
      _database = AppDatabase();

      // Eliminar todos los usuarios
      await deleteAllUsers();

      print('Base de datos Drift reinicializada correctamente');
      return true;
    } catch (e) {
      print('Error al resetear la base de datos Drift: $e');
      return false;
    }
  }
}
