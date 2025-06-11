import 'package:flutter/material.dart';

class ScheduledTasks extends StatefulWidget {
  const ScheduledTasks({super.key});

  @override
  _ScheduledTasksState createState() => _ScheduledTasksState();
}

class _ScheduledTasksState extends State<ScheduledTasks> {
  // Datos de ejemplo
  final List<Map<String, dynamic>> tareasEjemplo = [
    {
      'id': 1,
      'nombre': 'Revisar documentación del proyecto',
      'fecha': '15/05/2024',
      'hora': '09:00',
      'estado': 'Done',
      'prioridad': 'Alta'
    },
    {
      'id': 2,
      'nombre': 'Reunión con equipo de desarrollo',
      'fecha': '15/05/2024',
      'hora': '11:30',
      'estado': 'In Progress',
      'prioridad': 'Media'
    },
    {
      'id': 3,
      'nombre': 'Actualizar repositorio GitHub',
      'fecha': '16/05/2024',
      'hora': '14:00',
      'estado': 'To Do',
      'prioridad': 'Alta'
    },
    {
      'id': 4,
      'nombre': 'Preparar presentación para stakeholders',
      'fecha': '17/05/2024',
      'hora': '10:00',
      'estado': 'To Do',
      'prioridad': 'Media'
    },
    {
      'id': 5,
      'nombre': 'Revisar pull requests pendientes',
      'fecha': '15/05/2024',
      'hora': '16:45',
      'estado': 'To Do',
      'prioridad': 'Baja'
    }
  ];

  late List<Map<String, dynamic>> tareas;
  String filtroEstado = 'all';
  String orden = 'fecha';

  @override
  void initState() {
    super.initState();
    tareas = List.from(tareasEjemplo);
  }

  List<Map<String, dynamic>> get tareasFiltradas {
    return tareas.where((tarea) {
      if (filtroEstado == 'all') return true;
      return tarea['estado'] == filtroEstado;
    }).toList();
  }

  List<Map<String, dynamic>> get tareasOrdenadas {
    final List<Map<String, dynamic>> result = List.from(tareasFiltradas);
    
    result.sort((a, b) {
      if (orden == 'fecha') {
        // Convertir fecha de formato dd/mm/yyyy a Date para comparar
        final List<String> partsA = a['fecha'].split('/');
        final List<String> partsB = b['fecha'].split('/');
        
        final DateTime dateA = DateTime(
          int.parse(partsA[2]), 
          int.parse(partsA[1]), 
          int.parse(partsA[0])
        );
        
        final DateTime dateB = DateTime(
          int.parse(partsB[2]), 
          int.parse(partsB[1]), 
          int.parse(partsB[0])
        );
        
        return dateA.compareTo(dateB);
      } else {
        // Ordenar por prioridad
        final Map<String, int> prioridades = {
          'Alta': 1,
          'Media': 2,
          'Baja': 3
        };
        
        return prioridades[a['prioridad']]! - prioridades[b['prioridad']]!;
      }
    });
    
    return result;
  }

  void cambiarEstadoTarea(int id, String nuevoEstado) {
    setState(() {
      tareas = tareas.map((tarea) {
        if (tarea['id'] == id) {
          return {...tarea, 'estado': nuevoEstado};
        }
        return tarea;
      }).toList();
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
                          "Listado de tareas programadas",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Filtros y ordenación
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
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Filtrar por estado:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: filtroEstado,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  filtroEstado = newValue;
                                                });
                                              }
                                            },
                                            items: <String>['all', 'To Do', 'In Progress', 'Done']
                                                .map<DropdownMenuItem<String>>((String value) {
                                              String displayText = '';
                                              switch (value) {
                                                case 'all':
                                                  displayText = 'Todos';
                                                  break;
                                                case 'To Do':
                                                  displayText = 'Por hacer';
                                                  break;
                                                case 'In Progress':
                                                  displayText = 'En progreso';
                                                  break;
                                                case 'Done':
                                                  displayText = 'Completadas';
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
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Ordenar por:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: orden,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  orden = newValue;
                                                });
                                              }
                                            },
                                            items: <String>['fecha', 'prioridad']
                                                .map<DropdownMenuItem<String>>((String value) {
                                              String displayText = value == 'fecha' ? 'Fecha' : 'Prioridad';
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(displayText),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Listado de tareas
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.checklist,
                                      size: 20,
                                      color: Colors.indigo[600],
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Tareas programadas",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo[100],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    "${tareasFiltradas.length} ${tareasFiltradas.length == 1 ? 'tarea' : 'tareas'}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.indigo[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Lista de tareas
                            if (tareasOrdenadas.isEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                alignment: Alignment.center,
                                child: Text(
                                  "No hay tareas que coincidan con los filtros",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: tareasOrdenadas.map((tarea) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    tarea['nombre'],
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.calendar_today,
                                                        size: 16,
                                                        color: Colors.grey[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        tarea['fecha'],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 16,
                                                        color: Colors.grey[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        tarea['hora'],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: tarea['prioridad'] == 'Alta'
                                                    ? Colors.red[100]
                                                    : tarea['prioridad'] == 'Media'
                                                        ? Colors.amber[100]
                                                        : Colors.green[100],
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                tarea['prioridad'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: tarea['prioridad'] == 'Alta'
                                                      ? Colors.red[800]
                                                      : tarea['prioridad'] == 'Media'
                                                          ? Colors.amber[800]
                                                          : Colors.green[800],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Divider(color: Colors.grey[200]),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  tarea['estado'] == 'Done'
                                                      ? Icons.check_circle
                                                      : tarea['estado'] == 'In Progress'
                                                          ? Icons.timelapse
                                                          : Icons.circle_outlined,
                                                  size: 20,
                                                  color: tarea['estado'] == 'Done'
                                                      ? Colors.green[500]
                                                      : tarea['estado'] == 'In Progress'
                                                          ? Colors.blue[500]
                                                          : Colors.grey[400],
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  tarea['estado'] == 'Done'
                                                      ? 'Completada'
                                                      : tarea['estado'] == 'In Progress'
                                                          ? 'En progreso'
                                                          : 'Pendiente',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (tarea['estado'] != 'Done')
                                              OutlinedButton(
                                                onPressed: () {
                                                  cambiarEstadoTarea(
                                                    tarea['id'],
                                                    tarea['estado'] == 'To Do'
                                                        ? 'In Progress'
                                                        : 'Done',
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  side: BorderSide(color: Colors.grey[300]!),
                                                ),
                                                child: Text(
                                                  tarea['estado'] == 'To Do'
                                                      ? 'Comenzar'
                                                      : 'Completar',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.indigo[700],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Resumen
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${tareas.length}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Pendientes",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${tareas.where((t) => t['estado'] == 'To Do').length}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Completadas",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${tareas.where((t) => t['estado'] == 'Done').length}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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