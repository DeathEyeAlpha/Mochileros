// lib/screens/huesped/detalle_habitacion_huesped_screen.dart

import 'package:flutter/material.dart';
import '../../models/habitacion.dart';

class DetalleHabitacionHuespedScreen extends StatefulWidget {
  final Habitacion habitacion;
  const DetalleHabitacionHuespedScreen({Key? key, required this.habitacion}) : super(key: key);

  @override
  State<DetalleHabitacionHuespedScreen> createState() => _DetalleHabitacionHuespedScreenState();
}

class _DetalleHabitacionHuespedScreenState extends State<DetalleHabitacionHuespedScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imagenes = widget.habitacion.imagenes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Detalle', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.habitacion.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('US\$ ${widget.habitacion.precio.toStringAsFixed(2)} por noche', style: const TextStyle(fontSize: 16, color: Colors.teal)),
            const SizedBox(height: 16),

            //carrusel de imagenes
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
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                    style: IconButton.styleFrom(backgroundColor: Colors.black45),
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
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                     style: IconButton.styleFrom(backgroundColor: Colors.black45),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            //seccion de descripcion
            const Text('Esta habitación incluye:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '${widget.habitacion.banos} baño(s)\n${widget.habitacion.camas} cama(s)\n${widget.habitacion.descripcion}',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B5FB5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}