// lib/services/implementacion/reserva_service.dart

import '../../models/reserva.dart';
import '../interfaces/i_reserva_service.dart';

class ReservaService implements IReservaService {
  static int _nextId = 4; //contador para los nuevos IDs de reserva
  
  //simulamos nuestra base de datos de reservas, BORRAR LUEGO
  static final List<Reserva> _reservas = [
    Reserva(
      id: 0,
      idHabitacion: '1', 
      nombreUsuario: 'Michael Jackson',
      cedulaUsuario: '53206367',
      mailUsuario: 'michael@email.com',
      cantidadHuespedes: 5,
      //importante: para que el filtro funcione, pongo fechas pasadas
      fechaIn: DateTime(2025, 8, 20),
      fechaOut: DateTime(2025, 8, 25),
    ),
    Reserva(
      id: 1,
      idHabitacion: '1',
      nombreUsuario: 'Freddie Mercury',
      cedulaUsuario: '12345678',
      mailUsuario: 'freddie@email.com',
      cantidadHuespedes: 2,
      fechaIn: DateTime(2025, 10, 5),
      fechaOut: DateTime(2025, 10, 10),
    ),
    Reserva(
      id: 3,
      idHabitacion: '2',
      nombreUsuario: 'Elvis Presley',
      cedulaUsuario: '87654321',
      mailUsuario: 'elvis@email.com',
      cantidadHuespedes: 1,
      fechaIn: DateTime(2025, 11, 1),
      fechaOut: DateTime(2025, 11, 3),
    ),
  ];

  @override
  Future<bool> existeConflictoReserva(String idHabitacion, DateTime fechaIn, DateTime fechaOut) async {
    await Future.delayed(const Duration(milliseconds: 50)); //simulamos una pequeña demora
    
    //buscamos todas las reservas para la habitación dada
    final reservasDeLaHabitacion = _reservas.where((res) => res.idHabitacion == idHabitacion && res.estaActiva);

    for (final reservaExistente in reservasDeLaHabitacion) {
      //si el nuevo check-in es antes de que termine una reserva existente y
      // el nuevo check-out es después de que empiece esa misma reserva, entonces hay un conflicto.
      if (fechaIn.isBefore(reservaExistente.fechaOut) && fechaOut.isAfter(reservaExistente.fechaIn)) {
        return true; //encontramos un conflicto, retornamos true
      }
    }
    
    return false; //no se encontraron conflictos
  }

  @override
  Future<bool> crearReserva(Reserva reserva) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final nuevoId = 'res${_nextId++}';
    //usamos copyWith para asignar el nuevo ID, DESPUES SERA DESDE LA BASE DE DATOS
    _reservas.add(reserva.copyWith(id: nuevoId));
    return true;
  }

  @override
  Future<List<Reserva>> listarReservasPorHabitacion(String idHabitacion) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reservas.where((res) => res.idHabitacion == idHabitacion).toList();
  }

  @override
  Future<bool> cancelarReserva(String idReserva) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reservas.removeWhere((res) => res.id == idReserva);
    return true;
  }
  
  @override
  Future<List<Reserva>> listarTodasLasReservas() {
    throw UnimplementedError();
  }

  @override
  Future<List<Reserva>> listarReservasPorUsuario(String cedulaUsuario) async {
    await Future.delayed(const Duration(milliseconds: 500));
    //filtramos la lista para devolver solo las reservas del usuario con esa cédula
    return _reservas.where((res) => res.cedulaUsuario == cedulaUsuario).toList();
  }

  @override
  Future<Reserva?> getReservaPorId(String id) {
    throw UnimplementedError();
  }

  @override
  Future<bool> actualizarEstadoReserva(String idReserva, EstadoReserva nuevoEstado) {
    throw UnimplementedError();
  }

  @override
  Future<List<Reserva>> getReservasActivasPorUsuario(String cedulaUsuario) {
    throw UnimplementedError();
  }
}

//agregamos el copyWith al modelo para que funcione el crearReserva
extension ReservaCopyWith on Reserva {
  Reserva copyWith({String? id}) {
    return Reserva(
      id: id as int,
      idHabitacion: idHabitacion,
      mailUsuario: mailUsuario,
      cedulaUsuario: cedulaUsuario,
      nombreUsuario: nombreUsuario,
      cantidadHuespedes: cantidadHuespedes,
      fechaIn: fechaIn,
      fechaOut: fechaOut,
      estado: estado,
    );
  }
}