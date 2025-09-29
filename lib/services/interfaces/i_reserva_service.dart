//interface para el servicio de reservas
import '../../models/reserva.dart';

abstract class IReservaService {
  //crea una nueva reserva
  //retorna true si la reserva fue exitosa, false en caso contrario
  Future<bool> crearReserva(Reserva reserva);

  //lista todas las reservas del sistema, exclusivo para admin
  Future<List<Reserva>> listarTodasLasReservas();

  //lista las reservas de un usuario especifico por su cédula
  Future<List<Reserva>> listarReservasPorUsuario(String cedulaUsuario);

  //lista las reservas de una habitación específica
  Future<List<Reserva>> listarReservasPorHabitacion(String idHabitacion);

  //obtiene una reserva por su ID
  Future<Reserva?> getReservaPorId(String id);

  //cancela una reserva
  //basicamente cambia el estado de la reserva a "cancelada"
  Future<bool> cancelarReserva(String idReserva);

  //actualiza el estado de una reserva
  Future<bool> actualizarEstadoReserva(String idReserva, EstadoReserva nuevoEstado);

  //verifica si hay conflictos de reservas para una habitación en un rango de fechas
  //retorna true si hay conflicto (ya existe una reserva activa), false si está disponible
  Future<bool> existeConflictoReserva(
    String idHabitacion,
    DateTime fechaIn,
    DateTime fechaOut,
  );

  //obtiene las reservas activas de un usuario
  Future<List<Reserva>> getReservasActivasPorUsuario(String cedulaUsuario);
}