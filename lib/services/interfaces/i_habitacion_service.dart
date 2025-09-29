//interface para el servicio de habitaciones
import '../../models/habitacion.dart';

abstract class IHabitacionService {
  //crea una nueva habitación en el sistema
  //retorna true si la creación fue exitosa, false en caso contrario
  Future<bool> crearHabitacion(Habitacion habitacion);

  //lista todas las habitaciones del hostel
  Future<List<Habitacion>> listarHabitaciones();

  //obtiene una habitación por su ID
  Future<Habitacion?> getHabitacionPorId(String id);

  //busca habitaciones disponibles en un rango de fechas
  //retorna lista de habitaciones que no tienen reservas activas en esas fechas
  Future<List<Habitacion>> buscarHabitacionesDisponibles(
    DateTime fechaIn,
    DateTime fechaOut,
  );

  //actualiza la información de una habitación
  Future<bool> actualizarHabitacion(Habitacion habitacion);

  //elimina una habitación del sistema
  Future<bool> eliminarHabitacion(String id);

  //verifica si una habitación específica está disponible en un rango de fechas
  Future<bool> estaDisponible(
    String idHabitacion,
    DateTime fechaIn,
    DateTime fechaOut,
  );
}