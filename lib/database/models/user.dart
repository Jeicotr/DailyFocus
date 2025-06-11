/// Modelo de datos para representar un usuario en la base de datos.
class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  /// Constructor para crear una instancia de User.
  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Convierte un User a un Map para almacenarlo en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  /// Crea un User a partir de un Map obtenido de la base de datos.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  /// Crea una copia de User con algunos campos actualizados.
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}