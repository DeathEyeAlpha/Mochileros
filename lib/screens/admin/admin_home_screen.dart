// lib/screens/admin/admin_home_screen.dart

import 'package:flutter/material.dart';
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
  final IHabitacionService _habitacionService = HabitacionService();
  final TextEditingController _searchController = TextEditingController();

  //variables para manejar el estado de los datos
  late Future<List<Habitacion>> _futureHabitaciones;
  List<Habitacion> _todasLasHabitaciones = [];
  List<Habitacion> _habitacionesFiltradas = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  //metodo para cargar los datos desde el servicio
  void _cargarDatos() {
    setState(() {
      _futureHabitaciones = _habitacionService.listarHabitaciones();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //logica de búsqueda adaptada al modelo Habitacion
  void _buscarHabitacion(String query) {
    setState(() {
      if (query.isEmpty) {
        _habitacionesFiltradas = List.from(_todasLasHabitaciones);
      } else {
        _habitacionesFiltradas = _todasLasHabitaciones
            .where((habitacion) =>
                habitacion.numero.toString().contains(query.toLowerCase()) ||
                habitacion.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  //logica de eliminación usando el servicio
  void _eliminarHabitacion(String id) async {
    final bool exito = await _habitacionService.eliminarHabitacion(id);
    
    if (mounted) { //verifica si el widget sigue en pantalla, aparentemente evita errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exito ? 'Habitación eliminada exitosamente' : 'Error al eliminar'),
          backgroundColor: exito ? Colors.green : Colors.red,
        ),
      );

      if (exito) {
        //si se eliminó con éxito, volvemos a cargar los datos
        _cargarDatos();
      }
    }
  }

  void _mostrarDialogoEliminar(String id, String nombre) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirmar eliminación', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('¿Está seguro que desea eliminar "$nombre"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _eliminarHabitacion(id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  //navegación a la pantalla de crear
  void _navegarACrearHabitacion() async {
    //esperamos un resultado de la pantalla de creación
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CrearHabitacionScreen()),
    );
    //su el resultado es true significa que se creó una habitación y recargamos la lista
    if (resultado == true) {
      _cargarDatos();
    }
  }

  //nvegación a la pantalla de detalle
  void _verDetalleHabitacion(Habitacion habitacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleHabitacionScreen(habitacion: habitacion),
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF6B5FB5),
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        title: const Text('Administrador', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _buscarHabitacion,
              decoration: InputDecoration(
                hintText: 'Buscar por ID o nombre...',
                filled: true,
                fillColor: const Color(0xFFE8E5F0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          //se usa un FutureBuilder para manejar la carga de datos
          Expanded(
            child: FutureBuilder<List<Habitacion>>(
              future: _futureHabitaciones,
              builder: (context, snapshot) {
                //estado de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                //estado de error
                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
                }
                //datos cargados exitosamente
                if (snapshot.hasData) {
                  _todasLasHabitaciones = snapshot.data!;
                  //si es la primera vez que cargamos, poblamos la lista filtrada
                  if (_habitacionesFiltradas.isEmpty && _searchController.text.isEmpty) {
                     _habitacionesFiltradas = List.from(_todasLasHabitaciones);
                  }

                  if (_habitacionesFiltradas.isEmpty) {
                    return const Center(child: Text('No se encontraron habitaciones.'));
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _habitacionesFiltradas.length,
                    itemBuilder: (context, index) {
                      final habitacion = _habitacionesFiltradas[index];
                      return _buildHabitacionCard(habitacion);
                    },
                  );
                }
                //estado por defecto
                return const Center(child: Text('No hay habitaciones.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACrearHabitacion,
        backgroundColor: const Color(0xFFD4C5F9),
        child: const Icon(Icons.add, color: Color(0xFF6B5FB5), size: 32),
      ),
    );
  }

  Widget _buildHabitacionCard(Habitacion habitacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _verDetalleHabitacion(habitacion),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                habitacion.imagenes.isNotEmpty ? habitacion.imagenes[0] : 'https://via.placeholder.com/400x200',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habitacion.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Reservas ${habitacion.reservas}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _mostrarDialogoEliminar(habitacion.numero as String, habitacion.nombre),
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}