// lib/screens/guest/habitaciones_disponibles_screen.dart

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mochileros/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/habitacion.dart';
import '../../models/reserva.dart';
import '../../services/interfaces/i_habitacion_service.dart';
import '../../services/interfaces/i_reserva_service.dart';
import '../../services/implementacion/habitacion_service.dart';
import '../../services/implementacion/reserva_service.dart';
import 'detalle_habitacion_huesped_screen.dart'; 

class HabitacionesDisponiblesScreen extends StatefulWidget {
  final DateTime fechaCheckin;
  final DateTime fechaCheckout;

  const HabitacionesDisponiblesScreen({
    Key? key,
    required this.fechaCheckin,
    required this.fechaCheckout,
  }) : super(key: key);

  @override
  State<HabitacionesDisponiblesScreen> createState() => _HabitacionesDisponiblesScreenState();
}

class _HabitacionesDisponiblesScreenState extends State<HabitacionesDisponiblesScreen> {
  final IHabitacionService _habitacionService = HabitacionService();
  final IReservaService _reservaService = ReservaService();
  late Future<List<Habitacion>> _futureHabitacionesDisponibles;

   @override
  void initState() {
    super.initState(); 

    _futureHabitacionesDisponibles = _getHabitacionesDisponibles(widget.fechaCheckin,widget.fechaCheckout);
  }

  
  Future<List<Habitacion>> _getHabitacionesDisponibles(fechaCheckin,fechaCheckout) async {
    final resp = await Supabase.instance.client.rpc(
  'habitaciones_disponibles',
  params: {
    'fecha_checkin': fechaCheckin.toIso8601String(),
    'fecha_checkout': fechaCheckout.toIso8601String(),
  },
);
  if (resp == null) return []; // evita el null -> Iterable

final data = resp as List; // ya es una lista de mapas
final habitaciones = data
    .map((e) => Habitacion.fromJson(e as Map<String, dynamic>))
    .toList();
return habitaciones;
  }

  //funcion para navegar a la pantalla de detalle
  void _verDetalle(Habitacion habitacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleHabitacionHuespedScreen(habitacion: habitacion),
      ),
    );
  }

  //funcion para realizar la reserva
  void _realizarReserva(int habitacion,fechaCheckin,fechaCheckout) async {
    final correo = Supabase.instance.client.auth.currentUser?.email ?? '';
    try{
    final response = await supabase.from('Reserva').insert({
    'Checkin': fechaCheckin.toIso8601String().split('T')[0],
    'Checkout': fechaCheckout.toIso8601String().split('T')[0],
    'Correo': correo,
    'Habitacion': habitacion,
  });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Reserva creada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
        //despues de reservar, volvemos a la pantalla de inicio
        Navigator.of(context).popUntil((route) => route.isFirst);
      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Hubo un error al crear la reserva.$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
    
  }

  //funcion para mostrar el pop-up de confirmación
  void _mostrarDialogoConfirmacion(Habitacion habitacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Reserva'),
          content: Text(
            '¿Desea reservar la ${habitacion.nombre} desde el ${widget.fechaCheckin.day}/${widget.fechaCheckin.month} hasta el ${widget.fechaCheckout.day}/${widget.fechaCheckout.month}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); //cierra el dialogo
                _realizarReserva(habitacion.numero,widget.fechaCheckin,widget.fechaCheckout); //ejecuta la reserva
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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
        title: const Text('Habitaciones Disponibles', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Habitacion>>(
        future: _futureHabitacionesDisponibles,
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return  Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay habitaciones disponibles para las fechas seleccionadas.',
                textAlign: TextAlign.center,
              ),
            );
          }

          final habitaciones = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habitaciones.length,
            itemBuilder: (context, index) {
              return _buildHabitacionCard(habitaciones[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildHabitacionCard(Habitacion habitacion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              habitacion.imagenes.first,
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
                Row(
                  children: [
                    Text(habitacion.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text(
                        '\$${habitacion.precio.toStringAsFixed(2)} USD',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _verDetalle(habitacion),
                      icon: const Icon(Icons.visibility),
                      label: const Text('Ver'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B5FB5),
                        side: const BorderSide(color: Color(0xFF6B5FB5)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _mostrarDialogoConfirmacion(habitacion),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Reservar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
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