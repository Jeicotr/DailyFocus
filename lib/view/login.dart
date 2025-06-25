import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'menu.dart';

class LoginDailyFocus extends StatefulWidget {
  const LoginDailyFocus({super.key});

  @override
  _LoginDailyFocusState createState() => _LoginDailyFocusState();
}

class _LoginDailyFocusState extends State<LoginDailyFocus> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool showPassword = false;
  bool isLoading = false;
  String userError = '';
  String passwordError = '';
  String loginError = '';
  bool loginSuccess = false;

  void validateForm() {
    setState(() {
      userError = '';
      passwordError = '';
      loginError = '';
      loginSuccess = false;

      if (userController.text.isEmpty) {
        userError = 'El usuario es requerido';
      }

      if (passwordController.text.isEmpty) {
        passwordError = 'La contraseña es requerida';
      }
    });
  }

  Future<void> handleSubmit() async {
    validateForm();

    if (userError.isEmpty && passwordError.isEmpty) {
      setState(() => isLoading = true);

      try {
        // Verificar credenciales por defecto
        if (userController.text.trim() == "user@gmail.com" &&
            passwordController.text.trim() == "pass123") {
          setState(() {
            loginSuccess = true;
            loginError = '';
          });
          // Navegar al menú principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          return;
        }

        // Si no son las credenciales por defecto, intentar con la base de datos
        final user = await _databaseHelper.loginUser(
          userController.text.trim(),
          passwordController.text.trim(),
        );

        if (user != null) {
          setState(() {
            loginSuccess = true;
            loginError = '';
          });
          // Navegar al menú principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Error: credenciales incorrectas
          setState(() {
            loginError = 'Usuario o contraseña incorrectos';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                  const Icon(Icons.memory, color: Colors.indigo, size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    "Daily Focus",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      errorText: userError.isNotEmpty ? userError : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      errorText:
                          passwordError.isNotEmpty ? passwordError : null,
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : handleSubmit,
                    child: Text(isLoading ? "Iniciando sesión..." : "Ingresar"),
                  ),
                  if (loginError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        loginError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (loginSuccess)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
