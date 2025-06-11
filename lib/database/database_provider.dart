import 'package:flutter_dailyfocus/database/database_helper.dart';
import 'package:flutter_dailyfocus/database/models/user.dart' as model;
import 'package:flutter_dailyfocus/database/models/activity.dart';

/// Clase proveedora para la base de datos SQLite.
/// Implementa el patrón Singleton para asegurar una única instancia.
/// Sirve como puente entre el código existente y la implementación de SQLite.
class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static DatabaseHelper? _databaseHelper;

  // Constructor factory que devuelve la instancia singleton
  factory DatabaseProvider() {
    return _instance;
  }

  // Constructor privado para el patrón Singleton
  DatabaseProvider._internal();

  /// Obtiene la instancia del helper de la base de datos, creándola si no existe.
  Future<DatabaseHelper> get databaseHelper async {
    if (_databaseHelper != null) return _databaseHelper!;
    _databaseHelper = DatabaseHelper();
    return _databaseHelper!;
  }

  /// Cierra la conexión a la base de datos si está abierta.
  Future<void> closeDatabase() async {
    if (_databaseHelper != null) {
      print('Cerrando conexión a la base de datos SQLite...');
      await _databaseHelper!.close();
      _databaseHelper = null;
      print('Conexión a la base de datos SQLite cerrada');
    }
  }

  /// Inserta un nuevo usuario en la base de datos.
  /// Retorna el ID del usuario insertado, o -1 si el email ya existe.
  Future<int> insertUser(model.User user) async {
    try {
      final db = await databaseHelper;

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

      // Convertir el usuario a un Map para insertar en la base de datos SQLite
      final userMap = user.toMap();
      // Eliminar el id si es null para permitir autoincremento
      if (userMap['id'] == null) {
        userMap.remove('id');
      }

      // Insertar el usuario
      final id = await db.insertUser(userMap);
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
      final db = await databaseHelper;

      // Buscar el usuario en la base de datos SQLite
      final userMap = await db.getUserByEmail(email.trim().toLowerCase());

      if (userMap == null) {
        return null;
      }

      // Convertir el Map a nuestro modelo de usuario
      print('Usuario encontrado: ${userMap['name']}');
      return model.User.fromMap(userMap);
    } catch (e) {
      print('Error en getUserByEmail: $e');
      return null;
    }
  }

  /// Verifica las credenciales de un usuario para el inicio de sesión.
  /// Retorna el usuario si las credenciales son correctas, null en caso contrario.
  Future<model.User?> loginUser(String email, String password) async {
    try {
      final db = await databaseHelper;

      // Normalizar el email
      final normalizedEmail = email.trim().toLowerCase();
      print(
        'Intentando iniciar sesión con email normalizado: $normalizedEmail',
      );

      // Buscar el usuario en la base de datos SQLite
      final userMap = await db.loginUser(normalizedEmail, password);

      if (userMap == null) {
        print('Credenciales incorrectas para email: $normalizedEmail');
        return null;
      }

      // Convertir el Map a nuestro modelo de usuario
      print('Usuario autenticado: ${userMap['name']}');
      return model.User.fromMap(userMap);
    } catch (e) {
      print('Error en loginUser: $e');
      return null;
    }
  }

  /// Actualiza los datos de un usuario existente.
  /// Retorna true si la actualización fue exitosa, false en caso contrario.
  Future<bool> updateUser(model.User user) async {
    try {
      final db = await databaseHelper;

      // Convertir nuestro modelo a un Map para la base de datos SQLite
      final userMap = user.toMap();

      // Asegurarse de que el ID no sea null
      if (userMap['id'] == null) {
        print('Error: No se puede actualizar un usuario sin ID');
        return false;
      }

      // Actualizar el usuario en la base de datos SQLite
      final rowsAffected = await db.updateUser(userMap);
      return rowsAffected > 0;
    } catch (e) {
      print('Error en updateUser: $e');
      return false;
    }
  }

  /// Elimina un usuario de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteUser(int id) async {
    try {
      final db = await databaseHelper;
      return await db.deleteUser(id);
    } catch (e) {
      print('Error en deleteUser: $e');
      return 0;
    }
  }

  /// Obtiene todos los usuarios de la base de datos.
  Future<List<model.User>> getAllUsers() async {
    try {
      final db = await databaseHelper;
      final userMaps = await db.getAllUsers();
      print('Total de usuarios en la base de datos: ${userMaps.length}');

      // Convertir los Maps a nuestro modelo de usuario
      return userMaps.map((userMap) => model.User.fromMap(userMap)).toList();
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
      final db = await databaseHelper;
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
      // Si podemos obtener el helper de la base de datos, está inicializada
      await databaseHelper;
      return true;
    } catch (e) {
      print('Error al verificar la inicialización de la base de datos: $e');
      return false;
    }
  }

  /// Inserta una nueva actividad en la base de datos.
  /// Retorna el ID de la actividad insertada, o -1 si ocurre un error.
  Future<int> insertActivity(Activity activity) async {
    try {
      final db = await databaseHelper;

      // Convertir la actividad a un Map para insertar en la base de datos SQLite
      final activityMap = activity.toMap();
      // Eliminar el id si es null para permitir autoincremento
      if (activityMap['id'] == null) {
        activityMap.remove('id');
      }

      // Asegurarse de que createdAt tenga un valor
      if (activityMap['createdAt'] == null) {
        activityMap['created_at'] = DateTime.now().toIso8601String();
      } else {
        activityMap['created_at'] = activityMap['createdAt'];
        activityMap.remove('createdAt');
      }

      // Insertar la actividad
      final id = await db.insertActivity(activityMap);
      print('Actividad insertada con ID: $id');
      return id;
    } catch (e) {
      print('Error al insertar actividad: $e');
      return -1;
    }
  }

  /// Obtiene todas las actividades de la base de datos.
  Future<List<Activity>> getAllActivities() async {
    try {
      final db = await databaseHelper;
      final activityMaps = await db.getAllActivities();
      print('Total de actividades en la base de datos: ${activityMaps.length}');

      // Convertir los Maps a nuestro modelo de actividad
      return activityMaps.map((activityMap) {
        // Convertir created_at a createdAt para el modelo
        if (activityMap['created_at'] != null) {
          activityMap['createdAt'] = activityMap['created_at'];
        }
        return Activity.fromMap(activityMap);
      }).toList();
    } catch (e) {
      print('Error al obtener todas las actividades: $e');
      return [];
    }
  }

  /// Actualiza los datos de una actividad existente.
  /// Retorna true si la actualización fue exitosa, false en caso contrario.
  Future<bool> updateActivity(Activity activity) async {
    try {
      final db = await databaseHelper;

      // Convertir nuestro modelo a un Map para la base de datos SQLite
      final activityMap = activity.toMap();

      // Asegurarse de que el ID no sea null
      if (activityMap['id'] == null) {
        print('Error: No se puede actualizar una actividad sin ID');
        return false;
      }

      // Convertir createdAt a created_at para la base de datos
      if (activityMap['createdAt'] != null) {
        activityMap['created_at'] = activityMap['createdAt'];
        activityMap.remove('createdAt');
      }

      // Actualizar la actividad en la base de datos SQLite
      final rowsAffected = await db.updateActivity(activityMap);
      return rowsAffected > 0;
    } catch (e) {
      print('Error en updateActivity: $e');
      return false;
    }
  }

  /// Elimina una actividad de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteActivity(int id) async {
    try {
      final db = await databaseHelper;
      return await db.deleteActivity(id);
    } catch (e) {
      print('Error en deleteActivity: $e');
      return 0;
    }
  }

  /// Elimina todas las actividades de la base de datos.
  /// Retorna el número de filas afectadas.
  Future<int> deleteAllActivities() async {
    try {
      final db = await databaseHelper;
      final count = await db.deleteAllActivities();
      print('Se eliminaron $count actividades de la base de datos');
      return count;
    } catch (e) {
      print('Error al eliminar todas las actividades: $e');
      return 0;
    }
  }

  /// Elimina completamente la base de datos y la reinicializa.
  /// Útil para depuración y cuando se necesita un estado limpio.
  Future<bool> resetDatabase() async {
    try {
      print('Iniciando reseteo completo de la base de datos SQLite...');

      // Cerrar la conexión actual si existe
      await closeDatabase();

      // Crear una nueva instancia del helper de la base de datos
      _databaseHelper = DatabaseHelper();

      // Resetear la base de datos
      await _databaseHelper!.resetDatabase();

      print('Base de datos SQLite reinicializada correctamente');
      return true;
    } catch (e) {
      print('Error al resetear la base de datos SQLite: $e');
      return false;
    }
  }
}
