// lib/screens/huesped/mis_reservas_screen.dart

import 'package:flutter/material.dart';
import '../../models/habitacion.dart';
import '../../models/reserva.dart';
import '../../services/interfaces/i_habitacion_service.dart';
import '../../services/interfaces/i_reserva_service.dart';
import '../../services/implementacion/habitacion_service.dart';
import '../../services/implementacion/reserva_service.dart';
import 'detalle_habitacion_huesped_screen.dart';

//clase auxiliar para juntar los datos de una reserva y su habitación
class ReservaConHabitacion {
  final Reserva reserva;
  final Habitacion habitacion;
  ReservaConHabitacion({required this.reserva, required this.habitacion});
}

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({Key? key}) : super(key: key);

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  final IReservaService _reservaService = ReservaService();
  final IHabitacionService _habitacionService = HabitacionService();
  late Future<List<ReservaConHabitacion>> _futureMisReservas;

  @override
  void initState() {
    super.initState();
    _cargarMisReservas();
  }

  void _cargarMisReservas() {
    setState(() {
      _futureMisReservas = _getMisReservas();
    });
  }

  //funcion para obtener los datos combinados de reservas y habitaciones
  Future<List<ReservaConHabitacion>> _getMisReservas() async {
    //como no hay login, usamos la cédula de un usuario de prueba BORRAR LUEGO
    const cedulaUsuarioPrueba = '12345678'; // Cédula de Freddie Mercury
    
    //obtenemos las reservas y todas las habitaciones
    final misReservas = await _reservaService.listarReservasPorUsuario(cedulaUsuarioPrueba);
    final todasLasHabitaciones = await _habitacionService.listarHabitaciones();
    
    final datosCombinados = <ReservaConHabitacion>[];
    
    //combinamos los datos
    for (final reserva in misReservas) {
      final habitacionCorrespondiente = todasLasHabitaciones.firstWhere(
        (hab) => hab.numero == reserva.idHabitacion,
      );
      datosCombinados.add(ReservaConHabitacion(
        reserva: reserva,
        habitacion: habitacionCorrespondiente,
      ));
    }
    
    return datosCombinados;
  }
  
  void _cancelarReserva(String idReserva) async {
    final bool exito = await _reservaService.cancelarReserva(idReserva);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exito ? 'Reserva cancelada' : 'Error al cancelar'),
          backgroundColor: exito ? Colors.green : Colors.red,
        ),
      );
      if (exito) {
        _cargarMisReservas(); //recargamos la lista
      }
    }
  }

  void _mostrarDialogoCancelar(String idReserva, String nombreHabitacion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: Text('¿Estás seguro de que quieres cancelar tu reserva para la $nombreHabitacion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelarReserva(idReserva);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sí, cancelar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Mis Reservas', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ReservaConHabitacion>>(
        future: _futureMisReservas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar tus reservas.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aún no tienes ninguna reserva.'));
          }

          final misReservas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: misReservas.length,
            itemBuilder: (context, index) {
              return _buildReservaCard(misReservas[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildReservaCard(ReservaConHabitacion datos) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              datos.habitacion.imagenes.first,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(datos.habitacion.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetalleHabitacionHuespedScreen(habitacion: datos.habitacion)
                        ));
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('Ver'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B5FB5),
                        side: const BorderSide(color: Color(0xFF6B5FB5)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _mostrarDialogoCancelar(datos.reserva.id as String, datos.habitacion.nombre),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text('Cancelar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}