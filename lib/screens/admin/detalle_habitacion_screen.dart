// lib/screens/admin/detalle_habitacion_screen.dart

import 'package:flutter/material.dart';
import '../../models/habitacion.dart';
import '/screens/admin/admin_ver_reservas_screen.dart';
class DetalleHabitacionScreen extends StatefulWidget {
  final dynamic habitacion;

  const DetalleHabitacionScreen({Key? key, required this.habitacion})
      : super(key: key);

  @override
  State<DetalleHabitacionScreen> createState() =>
      _DetalleHabitacionScreenState();
}

class _DetalleHabitacionScreenState extends State<DetalleHabitacionScreen> {
  

   @override
  Widget build(BuildContext context) {
    final nombre = widget.habitacion['Nombre'] ?? 'Sin nombre';
    final descripcion = widget.habitacion['Descripcion'] ?? 'Sin descripción';
    final imagen = widget.habitacion['Imagen'] ?? '';
    final precio = widget.habitacion['Precio'] ?? 0;
    final cuartos = widget.habitacion['Cuartos'] ?? 0;
    final camas = widget.habitacion['Camas'] ?? 0;
    final banos = widget.habitacion['Baños'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: Text(nombre),
        backgroundColor: const Color(0xFF6B5FB5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imagen.isNotEmpty
                    ? imagen
                    : 'https://via.placeholder.com/400x250.png?text=Sin+imagen',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nombre y precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B5FB5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '\$${precio.toString()} USD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Detalles de cantidades
            const Text(
              'Detalles de la habitación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailIcon(Icons.meeting_room, 'Cuartos', cuartos),
                _buildDetailIcon(Icons.bed, 'Camas', camas),
                _buildDetailIcon(Icons.bathtub, 'Baños', banos),
              ],
            ),
            const SizedBox(height: 30),

            
          ],
        ),
      ),
    );
  }

  Widget _buildDetailIcon(IconData icon, String label, int value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E5F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6B5FB5), size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          '$value $label',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

}