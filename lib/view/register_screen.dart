import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../database/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool showPassword = false;
  bool isLoading = false;
  bool registerSuccess = false;
  String registerError = '';
  bool isResettingDb = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetDatabase() async {
    setState(() {
      isResettingDb = true;
      registerError = '';
      registerSuccess = false;
    });

    try {
      await _databaseHelper.resetDatabase(); // ya no se espera un resultado

      setState(() {
        nameController.clear();
        emailController.clear();
        passwordController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Base de datos reseteada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        registerError = 'Error al resetear la base de datos: ${e.toString()}';
      });
    } finally {
      setState(() => isResettingDb = false);
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      registerError = '';
      registerSuccess = false;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);

      try {
        final name = nameController.text.trim();
        final email = emailController.text.trim().toLowerCase();
        final password = passwordController.text.trim();

        final existingUser = await _databaseHelper.getUserByEmail(email);
        if (existingUser != null) {
          setState(() {
            registerError = 'Este correo electrónico ya está registrado';
          });
        } else {
          final user = User(name: name, email: email, password: password);
          final result = await _databaseHelper.insertUser(user.toMap());

          if (result > 0) {
            setState(() {
              registerSuccess = true;
              registerError = '';
            });
          } else {
            setState(() {
              registerError = 'Error al registrar usuario';
            });
          }
        }
      } catch (e) {
        setState(() {
          registerError = 'Error: ${e.toString()}';
        });
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
        title: const Text("Registro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_add,
                      color: Colors.indigo,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Crear una cuenta",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nombre
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Nombre"),
                      autofillHints: const [AutofillHints.name],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Correo electrónico",
                      ),
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'El correo es requerido';
                        final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                        if (!regex.hasMatch(email)) return 'Correo inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Contraseña
                    TextFormField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
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
                      autofillHints: const [AutofillHints.password],
                      validator: (value) {
                        final password = value?.trim() ?? '';
                        if (password.isEmpty)
                          return 'La contraseña es requerida';
                        if (password.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Botón de registro
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[600],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isLoading ? "Registrando..." : "Registrarse",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Mensajes
                    if (registerError.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        registerError,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                    if (registerSuccess) ...[
                      const SizedBox(height: 12),
                      Text(
                        "¡Registro exitoso! Ahora inicia sesión.",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
