// lib/screens/guest/reservar_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'habitaciones_disponibles_screen.dart'; 
import '../home.dart';

class ReservarScreen extends StatefulWidget {
  const ReservarScreen({Key? key}) : super(key: key);

  @override
  State<ReservarScreen> createState() => _ReservarScreenState();
}

class _ReservarScreenState extends State<ReservarScreen> {
  DateTime? _fechaCheckin;
  DateTime? _fechaCheckout;
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  Future<void> _seleccionarFechas(BuildContext context) async {
    final rangoFechas = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _fechaCheckin != null && _fechaCheckout != null
          ? DateTimeRange(start: _fechaCheckin!, end: _fechaCheckout!)
          : null,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B5FB5),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (rangoFechas != null) {
      setState(() {
        _fechaCheckin = rangoFechas.start;
        _fechaCheckout = rangoFechas.end;
      });
    }
  }

  void _buscarHabitaciones() {
    if (_fechaCheckin == null || _fechaCheckout == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione las fechas de check-in y check-out.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) => HabitacionesDisponiblesScreen(
           fechaCheckin: _fechaCheckin!,
           fechaCheckout: _fechaCheckout!,
         ),
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
        title: const Text('Reservar', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Ingresa las fechas de check-in y check-out. Luego, presiona "Buscar" para ver las habitaciones disponibles en ese período.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F6FD),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD4C5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _seleccionarFechas(context),
                    child: const Row(
                      children: [
                        Text('Checkin/Checkout', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Icon(Icons.calendar_month, color: Color(0xFF6B5FB5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildDateField('Checkin', _fechaCheckin)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDateField('Checkout', _fechaCheckout)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _fechaCheckin = null;
                            _fechaCheckout = null;
                          });
                        },
                        child: const Text('Limpiar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _seleccionarFechas(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B5FB5),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Elegir Fechas'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    //--- CAMBIO AQUÍ ---
                    onPressed: () {
                      //este comando abre Home y elimina todas las pantallas anteriores
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _buscarHabitaciones,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B5FB5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF6B5FB5)),
          ),
          child: Center(
            child: Text(
              date != null ? _formatter.format(date) : 'mm/dd/yyyy',
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}