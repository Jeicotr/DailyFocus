import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/users.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Ejemplo de métodos simples
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<User?> getUserByEmail(String email) {
    return (select(
      users,
    )..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  Future<User?> loginUser(String email, String password) {
    return (select(users)
          ..where((u) => u.email.equals(email.trim().toLowerCase()))
          ..where((u) => u.password.equals(password)))
        .getSingleOrNull();
  }

  Future<List<User>> getAllUsers() => select(users).get();

  Future<bool> updateUser(User user) => update(users).replace(user);

  Future<int> deleteUserById(int id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();

  Future<int> deleteAllUsers() => delete(users).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'daily_focus.db'));
    return NativeDatabase(file);
  });
}
