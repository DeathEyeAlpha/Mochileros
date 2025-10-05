// lib/models/reserva.dart

enum EstadoReserva {
  activa,
  cancelada,
  completada,
}

class Reserva {
  final String id;
  final String idHabitacion;
  final String mailUsuario;
  final String cedulaUsuario;
  final String nombreUsuario;
  final int cantidadHuespedes;
  final DateTime fechaIn;
  final DateTime fechaOut;
  final EstadoReserva estado;

  Reserva({
    required this.id,
    required this.idHabitacion,
    required this.mailUsuario,
    required this.cedulaUsuario,
    required this.nombreUsuario,
    required this.cantidadHuespedes,
    required this.fechaIn,
    required this.fechaOut,
    this.estado = EstadoReserva.activa,
  });
  
  //constructor desde JSON
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      idHabitacion: json['id_habitacion'],
      mailUsuario: json['mail_usuario'],
      cedulaUsuario: json['cedula_usuario'],
      nombreUsuario: json['nombre_usuario'],
      cantidadHuespedes: json['cantidad_huespedes'],
      fechaIn: DateTime.parse(json['fecha_in']),
      fechaOut: DateTime.parse(json['fecha_out']),
      estado: _estadoFromString(json['estado']),
    );
  }

  //convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_habitacion': idHabitacion,
      'mail_usuario': mailUsuario,
      'cedula_usuario': cedulaUsuario,
      'nombre_usuario': nombreUsuario,
      'cantidad_huespedes': cantidadHuespedes,
      'fecha_in': fechaIn.toIso8601String(),
      'fecha_out': fechaOut.toIso8601String(),
      'estado': estado.name
    };
  }

  static EstadoReserva _estadoFromString(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'cancelada': return EstadoReserva.cancelada;
      case 'completada': return EstadoReserva.completada;
      case 'activa': default: return EstadoReserva.activa;
    }
  }

  int get cantidadNoches => fechaOut.difference(fechaIn).inDays;
  bool get estaActiva => estado == EstadoReserva.activa;
  bool get yaPaso => DateTime.now().isAfter(fechaOut);

  @override
  String toString() => 'Reserva{id: $id, habitacion: $idHabitacion, usuario: $nombreUsuario}';
  @override
  bool operator ==(Object other) => identical(this, other) || other is Reserva && other.id == id;
  @override
  int get hashCode => id.hashCode;
}