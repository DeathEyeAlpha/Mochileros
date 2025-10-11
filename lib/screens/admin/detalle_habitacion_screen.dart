// lib/screens/admin/detalle_habitacion_screen.dart

import 'package:flutter/material.dart';
import '../../models/habitacion.dart';
import '/screens/admin/admin_ver_reservas_screen.dart';
class DetalleHabitacionScreen extends StatefulWidget {
  final Habitacion habitacion;

  const DetalleHabitacionScreen({Key? key, required this.habitacion})
      : super(key: key);

  @override
  State<DetalleHabitacionScreen> createState() =>
      _DetalleHabitacionScreenState();
}

class _DetalleHabitacionScreenState extends State<DetalleHabitacionScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> imagenes = widget.habitacion.imagenes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Detalle de Habitación',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habitacion.nombre,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Reservas: ${widget.habitacion.reservas}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imagenes[_currentImageIndex],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _currentImageIndex = (_currentImageIndex - 1 + imagenes.length) % imagenes.length;
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                    style: IconButton.styleFrom(backgroundColor: Colors.white70),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _currentImageIndex = (_currentImageIndex + 1) % imagenes.length;
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                     style: IconButton.styleFrom(backgroundColor: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Cuartos:', widget.habitacion.cuartos.toString()),
            _buildDetailRow('Camas:', widget.habitacion.camas.toString()),
            _buildDetailRow('Televisores:', widget.habitacion.televisores.toString()),
            _buildDetailRow('Baños:', widget.habitacion.banos.toString()),
            _buildDetailRow('Precio:', '\$${widget.habitacion.precio}'),
            const SizedBox(height: 20),
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.habitacion.descripcion,
              style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 30),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerReservasScreen(idHabitacion: widget.habitacion.numero as String),
                    ),
                  );
                },
                child: const Text('Ver Reservas'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6B5FB5),
                  side: const BorderSide(color: Color(0xFF6B5FB5)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }
}