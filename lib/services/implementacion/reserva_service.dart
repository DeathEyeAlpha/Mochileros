// lib/services/implementacion/reserva_service.dart

import '../../models/reserva.dart';
import '../interfaces/i_reserva_service.dart';

class ReservaService implements IReservaService {
  //simulamos nuestra base de datos de reservas
  static final List<Reserva> _reservas = [
    Reserva(
      id: 'res1',
      idHabitacion: '1', //esta reserva pertenece a la Habitación 1
      nombreUsuario: 'Michael Jackson',
      cedulaUsuario: '53206367',
      mailUsuario: 'michael@email.com',
      cantidadHuespedes: 5,
      fechaIn: DateTime(2024, 8, 9),
      fechaOut: DateTime(2024, 9, 11),
    ),
    Reserva(
      id: 'res2',
      idHabitacion: '1', //esta también
      nombreUsuario: 'Freddie Mercury',
      cedulaUsuario: '12345678',
      mailUsuario: 'freddie@email.com',
      cantidadHuespedes: 2,
      fechaIn: DateTime(2024, 10, 5),
      fechaOut: DateTime(2024, 10, 10),
    ),
    Reserva(
      id: 'res3',
      idHabitacion: '2', //esta reserva pertenece a la Habitación 2
      nombreUsuario: 'Elvis Presley',
      cedulaUsuario: '87654321',
      mailUsuario: 'elvis@email.com',
      cantidadHuespedes: 1,
      fechaIn: DateTime(2024, 11, 1),
      fechaOut: DateTime(2024, 11, 3),
    ),
  ];

  @override
  Future<List<Reserva>> listarReservasPorHabitacion(String idHabitacion) async {
    await Future.delayed(const Duration(milliseconds: 500));
    //filtramos la lista de reservas para devolver solo las de la habitación pedida
    return _reservas.where((res) => res.idHabitacion == idHabitacion).toList();
  }

  @override
  Future<bool> cancelarReserva(String idReserva) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reservas.removeWhere((res) => res.id == idReserva);
    return true;
  }
  
  @override
  Future<bool> crearReserva(Reserva reserva) {
    throw UnimplementedError();
  }

  @override
  Future<List<Reserva>> listarTodasLasReservas() {
    throw UnimplementedError();
  }

  @override
  Future<List<Reserva>> listarReservasPorUsuario(String cedulaUsuario) {
    throw UnimplementedError();
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
  Future<bool> existeConflictoReserva(String idHabitacion, DateTime fechaIn, DateTime fechaOut) {
    throw UnimplementedError();
  }

  @override
  Future<List<Reserva>> getReservasActivasPorUsuario(String cedulaUsuario) {
    throw UnimplementedError();
  }
}