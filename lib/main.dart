import 'package:flutter/material.dart';
import 'view/login.dart';
import 'view/register_screen.dart';
import 'view/notification_settings.dart';
import 'view/task_feedback.dart';
import 'view/scheduled_tasks.dart';
import 'view/activity_registration.dart';

/// Función principal que arranca la aplicación.
void main() {
  // Asegura que los widgets estén inicializados antes de usar la base de datos
  WidgetsFlutterBinding.ensureInitialized();

  runApp(DailyFocusApp());
}

/// DailyFocusApp es el widget raíz de la aplicación.
/// Se encarga de establecer el tema, título y la pantalla inicial (HomePage)
/// dentro de un MaterialApp, proporcionando dirección (Directionality) y otros
/// elementos propios del diseño material.
class DailyFocusApp extends StatelessWidget {
  const DailyFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daily Focus",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(),
    );
  }
}

/// HomePage es la pantalla principal de la aplicación Daily Focus.
/// Muestra el logotipo, título y botones para redireccionar a las pantallas de
/// inicio de sesión (LoginDailyFocus) y registro (RegisterScreen).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50], // Color de fondo inspirado en TSX
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Icono representativo de la aplicación dentro de un contenedor circular con sombra.
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo[600], // Fondo azul oscuro
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ], // Efecto de sombra
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.memory,
                  color: Colors.white,
                  size: 40,
                ), // Icono de la aplicación
              ),
              SizedBox(height: 20),

              /// Título de la aplicación "Daily Focus".
              Text(
                "Daily Focus",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                ),
              ),
              SizedBox(height: 6),

              /// Descripción breve debajo del título.
              Text(
                "Enfócate en lo que importa",
                style: TextStyle(fontSize: 16, color: Colors.indigo[600]),
              ),
              SizedBox(height: 30),

              /// Tarjeta con opciones de navegación.
              Card(
                elevation: 4, // Agrega sombra para efecto 3D
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ), // Bordes redondeados
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      /// Botón que redirige a la pantalla de Login (LoginDailyFocus).
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.indigo[600], // Color de fondo azul oscuro
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginDailyFocus(),
                            ),
                          );
                        },
                        child: Text(
                          "Iniciar sesión",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),

                      /// Botón que redirige a la pantalla de Registro (RegisterScreen).
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.indigo[400], // Color azul más claro
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Registrarse",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),

                      /// Botón que redirige a la pantalla de Configuración de Notificaciones.
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.indigo[300], // Color azul aún más claro
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationSettings(),
                            ),
                          );
                        },
                        child: Text(
                          "Configurar notificaciones",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),

                      /// Botón que redirige a la pantalla de Feedback de Tareas.
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.indigo[200], // Color azul más claro aún
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskFeedback(),
                            ),
                          );
                        },
                        child: Text(
                          "Seguimiento de tareas",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),

                      /// Botón que redirige a la pantalla de Tareas Programadas.
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.indigo[100], // Color azul aún más claro
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduledTasks(),
                            ),
                          );
                        },
                        child: Text(
                          "Tareas programadas",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      /// Botón que redirige a la pantalla de Registro de Actividades.
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo[800],
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.indigo[200]!),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityRegistration(),
                            ),
                          );
                        },
                        child: Text(
                          "Registro de actividades",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
