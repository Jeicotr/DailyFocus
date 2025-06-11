/// Modelo de datos para representar una actividad en la base de datos.
class Activity {
  final int? id;
  final String name;
  final String date;
  final String time;
  final String status;
  final DateTime? createdAt;

  /// Constructor para crear una instancia de Activity.
  Activity({
    this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.status,
    this.createdAt,
  });

  /// Convierte un Activity a un Map para almacenarlo en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Crea un Activity a partir de un Map obtenido de la base de datos.
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      time: map['time'],
      status: map['status'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  /// Crea una copia de Activity con algunos campos actualizados.
  Activity copyWith({
    int? id,
    String? name,
    String? date,
    String? time,
    String? status,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Activity(id: $id, name: $name, date: $date, time: $time, status: $status)';
  }
}