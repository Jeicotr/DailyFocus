import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  String notificationType = 'fixed';
  String frequency = 'daily';
  double reminderTime = 15;
  bool saved = false;

  void handleSubmit() {
    // Simulación de guardado
    setState(() {
      saved = true;
    });
    
    // Resetear el estado después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          saved = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.indigo[100]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  children: [
                    // Header con logo
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo[600],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.psychology,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Daily Focus",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[800],
                          ),
                        ),
                        Text(
                          "Configuración de notificaciones",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Card principal
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Encabezado de la tarjeta
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications,
                                  size: 20,
                                  color: Colors.indigo[600],
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Preferencias de notificación",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Personaliza cómo y cuándo recibir recordatorios",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Formulario
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tipo de notificación
                                const Text(
                                  "Tipo de recordatorio",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    // Opción Horario fijo
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            notificationType = 'fixed';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: notificationType == 'fixed'
                                                  ? Colors.indigo
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 24,
                                                color: notificationType == 'fixed'
                                                    ? Colors.indigo
                                                    : Colors.grey[600],
                                              ),
                                              const SizedBox(height: 8),
                                              const Text("Horario fijo"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Opción Relativo a tarea
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            notificationType = 'relative';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: notificationType == 'relative'
                                                  ? Colors.indigo
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.notifications,
                                                size: 24,
                                                color: notificationType == 'relative'
                                                    ? Colors.indigo
                                                    : Colors.grey[600],
                                              ),
                                              const SizedBox(height: 8),
                                              const Text("Relativo a tarea"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                
                                // Configuración según tipo seleccionado
                                if (notificationType == 'fixed') ...[
                                  const Text(
                                    "Frecuencia",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: frequency,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              frequency = newValue;
                                            });
                                          }
                                        },
                                        items: <String>['daily', 'weekly', 'weekdays', 'custom']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          String displayText = '';
                                          switch (value) {
                                            case 'daily':
                                              displayText = 'Diariamente';
                                              break;
                                            case 'weekly':
                                              displayText = 'Semanalmente';
                                              break;
                                            case 'weekdays':
                                              displayText = 'Días laborables';
                                              break;
                                            case 'custom':
                                              displayText = 'Personalizado';
                                              break;
                                          }
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(displayText),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Hora de notificación",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: '09:00',
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        onChanged: (String? newValue) {
                                          // Implementar cambio de hora
                                        },
                                        items: List.generate(24, (index) {
                                          final hour = index < 10 ? '0$index' : '$index';
                                          return DropdownMenuItem<String>(
                                            value: '$hour:00',
                                            child: Text('$hour:00'),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  // Configuración para notificaciones relativas
                                  Row(
                                    children: [
                                      const Text(
                                        "Recordatorio antes de la tarea",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${reminderTime.toInt()} min",
                                        style: TextStyle(
                                          color: Colors.indigo[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Slider(
                                    value: reminderTime,
                                    min: 5,
                                    max: 120,
                                    divisions: 23, // (120-5)/5 = 23 steps
                                    activeColor: Colors.indigo[600],
                                    inactiveColor: Colors.indigo[100],
                                    onChanged: (value) {
                                      setState(() {
                                        reminderTime = value;
                                      });
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "5 min",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        "2 horas",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 24),
                                
                                // Mensaje de guardado
                                if (saved)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: Colors.green[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Configuración guardada",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 16),
                                
                                // Botón de guardar
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: handleSubmit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo[600],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Guardar configuración",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Información adicional
                    const SizedBox(height: 16),
                    Text(
                      "Las notificaciones se enviarán según estas preferencias",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
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