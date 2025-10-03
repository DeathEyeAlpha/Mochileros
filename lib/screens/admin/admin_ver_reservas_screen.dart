// lib/screens/admin/admin_ver_reservas_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //paquete para formatear fechas
import '../../models/reserva.dart';
import '/services/interfaces/i_reserva_service.dart';
import '/services/implementacion/reserva_service.dart';

class VerReservasScreen extends StatefulWidget {
  final String idHabitacion;
  const VerReservasScreen({Key? key, required this.idHabitacion}) : super(key: key);

  @override
  State<VerReservasScreen> createState() => _VerReservasScreenState();
}

class _VerReservasScreenState extends State<VerReservasScreen> {
  final IReservaService _reservaService = ReservaService();
  late Future<List<Reserva>> _futureReservas;

  @override
  void initState() {
    super.initState();
    _cargarReservas();
  }

  void _cargarReservas() {
    setState(() {
      _futureReservas = _reservaService.listarReservasPorHabitacion(widget.idHabitacion);
    });
  }

  void _eliminarReserva(String idReserva) async {
    bool exito = await _reservaService.cancelarReserva(idReserva);
    if (mounted && exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva eliminada'), backgroundColor: Colors.green),
      );
      _cargarReservas(); //recargamos la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reservas de la Habitación', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<List<Reserva>>(
        future: _futureReservas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
              return _buildReservaCard(reserva);
            },
          );
        },
      ),
    );
  }

  //widget para construir cada tarjeta de reserva
  Widget _buildReservaCard(Reserva reserva) {
    //formateador de fecha
    final DateFormat formatter = DateFormat('dd/MM/yy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: const Color(0xFFF8F6FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reserva ${reserva.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Check-in:', formatter.format(reserva.fechaIn)),
                _buildInfoColumn('Check-out:', formatter.format(reserva.fechaOut)),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoColumn('Reservado por:', reserva.nombreUsuario),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('C.I:', reserva.cedulaUsuario),
                _buildInfoColumn('Cant. Huespedes:', reserva.cantidadHuespedes.toString()),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _eliminarReserva(reserva.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //widget para no repetir codigo de las columnas de info
  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}