import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../database/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores de los campos
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instancia del helper de base de datos
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool showPassword = false;
  bool isLoading = false;
  String nameError = '';
  String emailError = '';
  String passwordError = '';
  String registerError = '';
  bool registerSuccess = false;
  bool isResettingDb = false;

  /// Valida localmente cada campo
  void _validateForm() {
    setState(() {
      nameError = '';
      emailError = '';
      passwordError = '';
      registerError = '';
      registerSuccess = false;

      if (nameController.text.isEmpty) nameError = 'El nombre es requerido';
      if (emailController.text.isEmpty) {
        emailError = 'El email es requerido';
      } else if (!RegExp(
        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      ).hasMatch(emailController.text))
        emailError = 'Ingresa un email válido';
      if (passwordController.text.isEmpty) {
        passwordError = 'La contraseña es requerida';
      } else if (passwordController.text.length < 6)
        passwordError = 'Mínimo 6 caracteres';
    });
  }

  /// Resetea completamente la base de datos para depuración
  Future<void> _resetDatabase() async {
    setState(() {
      isResettingDb = true;
      registerError = '';
      registerSuccess = false;
    });

    try {
      print('Solicitando reseteo de la base de datos...');
      final result = await _databaseHelper.resetDatabase();
      print('Resultado del reseteo de la base de datos: $result');

      if (result) {
        setState(() {
          registerError = '';
          registerSuccess = false;
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        });

        // Verificar el estado de la base de datos después del reseteo
        final isInitialized = await _databaseHelper.isDatabaseInitialized();
        print('Base de datos inicializada después del reseteo: $isInitialized');

        // Verificar si hay usuarios en la base de datos
        final users = await _databaseHelper.getAllUsers();
        print(
          'Usuarios en la base de datos después del reseteo: ${users.length}',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Base de datos reseteada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          registerError = 'Error al resetear la base de datos';
        });
      }
    } catch (e) {
      print('Error al resetear la base de datos: $e');
      setState(() {
        registerError = 'Error al resetear la base de datos: ${e.toString()}';
      });
    } finally {
      setState(() => isResettingDb = false);
    }
  }

  /// Registra un nuevo usuario en la base de datos SQLite
  Future<void> _handleRegister() async {
    _validateForm();
    if (nameError.isEmpty && emailError.isEmpty && passwordError.isEmpty) {
      setState(() => isLoading = true);

      try {
        // Obtener y normalizar los datos del formulario
        final name = nameController.text.trim();
        final email = emailController.text.trim().toLowerCase();
        final password = passwordController.text.trim();

        print('Intentando registrar usuario con email: $email');

        // Verificar si la base de datos está inicializada
        final isInitialized = await _databaseHelper.isDatabaseInitialized();
        print('Base de datos inicializada: $isInitialized');

        // Verificar si el email ya existe directamente
        final existingUser = await _databaseHelper.getUserByEmail(email);
        print('Usuario existente con este email: ${existingUser != null}');

        // Crear objeto User con los datos del formulario
        final user = User(name: name, email: email, password: password);

        // Insertar usuario en la base de datos
        print('Llamando a insertUser con email: $email');
        final result = await _databaseHelper.insertUser(user);
        print('Resultado de insertUser: $result');

        if (result > 0) {
          // Éxito: se insertó el usuario (result es el ID)
          print('Usuario registrado exitosamente con ID: $result');
          setState(() {
            registerSuccess = true;
            registerError = '';
          });
        } else if (result == -1) {
          // Error: email ya existe
          print('Error: email ya registrado: $email');
          setState(() {
            registerError = 'Este correo electrónico ya está registrado';
          });
        } else {
          // Otro error
          print('Error desconocido al registrar usuario, código: $result');
          setState(() {
            registerError = 'Error al registrar usuario';
          });
        }
      } catch (e) {
        print('Excepción al registrar usuario: $e');
        setState(() => registerError = 'Error: ${e.toString()}');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text("Registro"),
        actions: [
          // Botón para resetear la base de datos (solo para depuración)
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Resetear base de datos',
            onPressed: isResettingDb ? null : _resetDatabase,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, color: Colors.indigo, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "Crear una cuenta",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Nombre
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      errorText: nameError.isNotEmpty ? nameError : null,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      errorText: emailError.isNotEmpty ? emailError : null,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Contraseña
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      errorText: passwordError.isNotEmpty
                          ? passwordError
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Botón Registrar
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[600],
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isLoading ? "Registrando..." : "Registrarse",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  // Mensajes de error / éxito
                  if (registerError.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(
                      registerError,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                  if (registerSuccess) ...[
                    SizedBox(height: 12),
                    Text(
                      "¡Registro exitoso! Ahora inicia sesión.",
                      style: TextStyle(color: Colors.green[700], fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
