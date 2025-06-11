import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class LoginDailyFocus extends StatefulWidget {
  const LoginDailyFocus({super.key});

  @override
  _LoginDailyFocusState createState() => _LoginDailyFocusState();
}

class _LoginDailyFocusState extends State<LoginDailyFocus> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool showPassword = false;
  bool isLoading = false;
  String emailError = '';
  String passwordError = '';
  String loginError = '';
  bool loginSuccess = false;

  void validateForm() {
    setState(() {
      emailError = '';
      passwordError = '';
      loginError = '';
      loginSuccess = false;

      if (emailController.text.isEmpty) {
        emailError = 'El email es requerido';
      } else if (!RegExp(
        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      ).hasMatch(emailController.text)) {
        emailError = 'Por favor ingresa un email válido';
      }

      if (passwordController.text.isEmpty) {
        passwordError = 'La contraseña es requerida';
      } else if (passwordController.text.length < 6) {
        passwordError = 'La contraseña debe tener al menos 6 caracteres';
      }
    });
  }

  Future<void> handleSubmit() async {
    validateForm();

    if (emailError.isEmpty && passwordError.isEmpty) {
      setState(() => isLoading = true);

      try {
        // Intentar iniciar sesión con las credenciales proporcionadas
        final user = await _databaseHelper.loginUser(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (user != null) {
          // Éxito: credenciales correctas
          setState(() {
            loginSuccess = true;
            loginError = '';
          });
        } else {
          // Error: credenciales incorrectas
          setState(() {
            loginError = 'Correo o contraseña incorrectos';
          });
        }
      } catch (e) {
        setState(() => loginError = 'Error: ${e.toString()}');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.memory, color: Colors.indigo, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "Daily Focus",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      errorText: emailError.isNotEmpty ? emailError : null,
                    ),
                  ),
                  SizedBox(height: 10),
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
                        ),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : handleSubmit,
                    child: Text(isLoading ? "Iniciando sesión..." : "Ingresar"),
                  ),
                  if (loginError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        loginError,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (loginSuccess)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "¡Inicio de sesión exitoso!",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
