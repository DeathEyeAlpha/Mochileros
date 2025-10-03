// lib/services/habitacion_service.dart

import '/models/habitacion.dart';
import '/services/interfaces/i_habitacion_service.dart';

//implementacion del servicio que maneja los datos de las habitaciones
class HabitacionService implements IHabitacionService {
  
  //lista estatica que simula la base de datos en memoria, BORRAR LUEGO
  static final List<Habitacion> _habitaciones = [
    Habitacion(
      id: '1',
      nombre: 'Habitacion 1',
      reservas: 2,
      imagenes: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1595526114035-0d45ed16433d?w=800',
      ],
      cuartos: 2,
      camas: 3,
      televisores: 2,
      banos: 1,
      precio: 500,
      descripcion: 'Una habitacion de ensueño para muchos. Equipada con los mejores lujos del mercado. Eso es todo, no hay nada mas que decir :)',
    ),
    Habitacion(
      id: '2',
      nombre: 'Habitacion 2',
      reservas: 0,
      imagenes: [
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
      ],
      cuartos: 1,
      camas: 1,
      televisores: 1,
      banos: 1,
      precio: 350,
      descripcion: 'Una habitación acogedora perfecta para viajeros solitarios o parejas. Simple, cómoda y con todo lo necesario.',
    ),
  ];

  // Lo inicializamos en 3 porque ya tenemos las habitaciones '1' y '2'.
  static int _nextId = 3;

  @override
  Future<List<Habitacion>> listarHabitaciones() async {
    //simulamos un retraso, por que seria gracioso           <<es como si se estuviera llamando a una API>> 
    await Future.delayed(const Duration(milliseconds: 500));
    return _habitaciones;
  }
  
  @override
  Future<bool> crearHabitacion(Habitacion habitacion) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    //MAS TARDE EL ID SE GENERA DESDE LA BASE DE DATOS, POR AHORA LO HACEMOS ASI
    final String nuevoId = (_nextId++).toString();
    
    //se crea una copia del objeto con el ID asignado
    final habitacionConIdAsignado = habitacion.copyWith(id: nuevoId);

    //se añade a la lista, MAS TARDE SE HARA EN LA BASE DE DATOS
    _habitaciones.add(habitacionConIdAsignado);
    
    return true; 
  }
  
  @override
  Future<bool> eliminarHabitacion(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _habitaciones.removeWhere((hab) => hab.id == id);
    return true;
  }

  //Todavia sin implementar 
  @override
  Future<Habitacion?> getHabitacionPorId(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Habitacion>> buscarHabitacionesDisponibles(DateTime fechaIn, DateTime fechaOut) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> actualizarHabitacion(Habitacion habitacion) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> estaDisponible(String idHabitacion, DateTime fechaIn, DateTime fechaOut) async {
    throw UnimplementedError();
  }
}