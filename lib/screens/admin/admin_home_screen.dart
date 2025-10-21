// lib/screens/admin/admin_home_screen.dart

import 'package:flutter/material.dart';
import 'package:mochileros/screens/admin/admin_ver_reservas_screen.dart';

import '../../main.dart';
import '/models/habitacion.dart';
import '/services/interfaces/i_habitacion_service.dart';
import '/services/implementacion/habitacion_service.dart';
import 'package:mochileros/screens/admin/crear_habitacion_screen.dart';
import 'package:mochileros/screens/admin/detalle_habitacion_screen.dart';


class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  //instancia del servicio de habitaciones
  late Future<List<dynamic>> _futureHabitaciones;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void salir() async {
  try {
    await supabase.auth.signOut();

    // Navegar a la pantalla principal (por ejemplo LoginScreen o Home)
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false, // elimina todas las pantallas anteriores
      );
    }

    debugPrint('✅ Sesión cerrada correctamente');
  } catch (e) {
    debugPrint('❌ Error al cerrar sesión: $e');
  }
}

  Future<void> _cargarDatos() async {
    final response = await supabase.from('Habitacion').select();
    debugPrint('🟢 Respuesta Supabase: $response');

    setState(() {
      _futureHabitaciones = Future.value(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: const Text('Habitaciones'),
        backgroundColor: const Color(0xFF6B5FB5),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: salir,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureHabitaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay habitaciones disponibles.'));
          }

          final habitaciones = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habitaciones.length,
            itemBuilder: (context, index) {
              final habitacion = habitaciones[index];
              final numero = habitacion['Numero'] ?? 0;
              final nombre = habitacion['Nombre'] ?? 'Sin nombre';
              final precio = habitacion['Precio'] ?? 0;
              final imagen = habitacion['Imagen'] ?? '';

              return GestureDetector(
                onTap: () {
                  // Abrir pantalla de detalle con todos los datos
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleHabitacionScreen(
                          habitacion: habitacion,
                        ),
                      ),
                    );
                  
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen superior
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          imagen.isNotEmpty
                              ? imagen
                              : 'https://via.placeholder.com/400x200.png?text=Sin+imagen',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 180, color: Colors.grey[300]),
                        ),
                      ),
                      // Información de la habitación
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nombre,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${precio.toString()} USD / noche',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B5FB5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botón Ver Reservas
                            ElevatedButton.icon(
                              onPressed: () {
                                
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerReservasScreen(numero: numero,nombre: nombre),
                                    ),
                                  );
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B5FB5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              icon: const Icon(Icons.list_alt, size: 20, color: Colors.white),
                              label: const Text(
                                'Ver reservas',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
    onPressed: () async {
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CrearHabitacionScreen()),
      );
      if (resultado == true) {
    _cargarDatos(); // recarga la lista
  }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(18),
      elevation: 6,
    ),
    child: const Icon(
      Icons.add,
      color: Colors.white,
      size: 30,
    ),
  ),
    );
  }
}