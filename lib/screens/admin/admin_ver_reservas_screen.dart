// lib/screens/admin/admin_ver_reservas_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //paquete para formatear fechas
import 'package:mochileros/main.dart';
import '../../models/reserva.dart';
import '/services/interfaces/i_reserva_service.dart';
import '/services/implementacion/reserva_service.dart';

class VerReservasScreen extends StatefulWidget {
  final int numero;
  final String nombre;
  const VerReservasScreen({Key? key,required this.numero,required this.nombre}) : super(key: key);

  @override
  State<VerReservasScreen> createState() => _VerReservasScreenState();
}

class _VerReservasScreenState extends State<VerReservasScreen> {

  late Future<List<dynamic>> _futureReservas;

  @override
  void initState() {
    super.initState();
    _futureReservas = obtenerReservasPorHabitacion(widget.numero);
  }

  Future<List<dynamic>> obtenerReservasPorHabitacion(int numeroHabitacion) async {
    final response = await supabase
        .from('Reserva')
        .select()
        .eq('Habitacion', numeroHabitacion);

    debugPrint('🟢 Reservas de habitación $numeroHabitacion: $response');
    return response;
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habitación ${widget.nombre}'),
        backgroundColor: const Color(0xFF6B5FB5),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureReservas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay reservas para esta habitación.'));
          }

          final reservas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reserva = reservas[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.purple),
                  title: Text(
                    'Usuario: ${reserva['Correo']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Check-in: ${reserva['Checkin']}\nCheck-out: ${reserva['Checkout']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }




}