/// Definición de la tabla de actividades para SQLite
class Activities {
  static const String tableName = 'activities';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDate = 'date';
  static const String columnTime = 'time';
  static const String columnStatus = 'status';
  static const String columnCreatedAt = 'created_at';

  /// Crea la tabla de actividades en la base de datos
  static String createTable() {
    return '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL
      )
    ''';
  }
}