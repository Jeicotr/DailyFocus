import 'dart:math';
import 'package:flutter/material.dart';

class TaskFeedback extends StatefulWidget {
  const TaskFeedback({super.key});

  @override
  _TaskFeedbackState createState() => _TaskFeedbackState();
}

class _TaskFeedbackState extends State<TaskFeedback> with SingleTickerProviderStateMixin {
  int completedTasks = 0;
  bool showFeedback = false;
  String currentFeedback = '';
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> messages = [
    {
      'text': '¡Excelente trabajo!',
      'icon': Icons.star,
      'color': Colors.amber,
    },
    {
      'text': '¡Lo hiciste genial!',
      'icon': Icons.emoji_events,
      'color': Colors.orange,
    },
    {
      'text': '¡Sigue así!',
      'icon': Icons.bolt,
      'color': Colors.blue,
    },
    {
      'text': '¡Tarea completada con éxito!',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void completeTask() {
    final randomMessage = messages[Random().nextInt(messages.length)];
    setState(() {
      currentFeedback = randomMessage['text'];
      completedTasks++;
      showFeedback = true;
    });

    _animationController.reset();
    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showFeedback = false;
        });
        _animationController.reverse();
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
                          "Motivación al completar tareas",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tarjeta principal
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Progreso de tareas",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "$completedTasks",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              completedTasks == 0
                                  ? "¡Completa tu primera tarea!"
                                  : completedTasks == 1
                                      ? "Has completado 1 tarea"
                                      : "Has completado $completedTasks tareas",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: completeTask,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Marcar como completada",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sección de logros
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
                            const Text(
                              "Tus logros",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Logro 1
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: completedTasks >= 1
                                    ? Colors.green[50]
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: completedTasks >= 1
                                          ? Colors.green[100]
                                          : Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 20,
                                      color: completedTasks >= 1
                                          ? Colors.green[600]
                                          : Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Primer tarea completada",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: completedTasks >= 1
                                                ? Colors.green[800]
                                                : Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          completedTasks >= 1
                                              ? "¡Logrado!"
                                              : "Completa 1 tarea",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Logro 2
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: completedTasks >= 5
                                    ? Colors.blue[50]
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: completedTasks >= 5
                                          ? Colors.blue[100]
                                          : Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      size: 20,
                                      color: completedTasks >= 5
                                          ? Colors.blue[600]
                                          : Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Estrella emergente",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: completedTasks >= 5
                                                ? Colors.blue[800]
                                                : Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          completedTasks >= 5
                                              ? "¡Logrado!"
                                              : "Completa 5 tareas",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Logro 3
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: completedTasks >= 10
                                    ? Colors.purple[50]
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: completedTasks >= 10
                                          ? Colors.purple[100]
                                          : Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.emoji_events,
                                      size: 20,
                                      color: completedTasks >= 10
                                          ? Colors.purple[600]
                                          : Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Maestro de productividad",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: completedTasks >= 10
                                                ? Colors.purple[800]
                                                : Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          completedTasks >= 10
                                              ? "¡Logrado!"
                                              : "Completa 10 tareas",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
          ),
        ),
      ),
      // Feedback flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFeedback
          ? FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.indigo[100]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForMessage(currentFeedback),
                        size: 32,
                        color: _getColorForMessage(currentFeedback),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentFeedback,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[800],
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "¡Sigue progresando!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  IconData _getIconForMessage(String message) {
    final messageData = messages.firstWhere(
      (element) => element['text'] == message,
      orElse: () => messages[0],
    );
    return messageData['icon'];
  }

  Color _getColorForMessage(String message) {
    final messageData = messages.firstWhere(
      (element) => element['text'] == message,
      orElse: () => messages[0],
    );
    return messageData['color'];
  }
}