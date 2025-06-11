/// Definición de la tabla de usuarios para SQLite
class Users {
  static const String tableName = 'users';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  /// Crea la tabla de usuarios en la base de datos
  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL CHECK(length($columnName) BETWEEN 1 AND 50),
        $columnEmail TEXT NOT NULL UNIQUE CHECK(length($columnEmail) BETWEEN 5 AND 100),
        $columnPassword TEXT NOT NULL CHECK(length($columnPassword) BETWEEN 6 AND 100)
      )
    ''';
  }
}