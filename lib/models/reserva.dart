//modelo de reserva
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
  final DateTime fechaIn;
  final DateTime fechaOut;
  final EstadoReserva estado;

  Reserva({
    required this.id,
    required this.idHabitacion,
    required this.mailUsuario,
    required this.cedulaUsuario,
    required this.fechaIn,
    required this.fechaOut,
    this.estado = EstadoReserva.activa,
  });

  //constructor desde JSON
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'] as String,
      idHabitacion: json['id_habitacion'] as String,
      mailUsuario: json['mail_usuario'] as String,
      cedulaUsuario: json['cedula_usuario'] as String,
      fechaIn: DateTime.parse(json['fecha_in'] as String),
      fechaOut: DateTime.parse(json['fecha_out'] as String),
      estado: _estadoFromString(json['estado'] as String?),
    );
  }

  //convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_habitacion': idHabitacion,
      'mail_usuario': mailUsuario,
      'cedula_usuario': cedulaUsuario,
      'fecha_in': fechaIn.toIso8601String(),
      'fecha_out': fechaOut.toIso8601String(),
      'estado': estado.name
    };
  }

  //este metodo es para convertir string a enum
  static EstadoReserva _estadoFromString(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'cancelada':
        return EstadoReserva.cancelada;
      case 'completada':
        return EstadoReserva.completada;
      case 'activa':
      default:
        return EstadoReserva.activa;
    }
  }

  //calcula cantidad de noches
  int get cantidadNoches {
    return fechaOut.difference(fechaIn).inDays;
  }

  //verifica si la reserva está activa
  bool get estaActiva => estado == EstadoReserva.activa;

  //verifica si la reserva ya pasó
  bool get yaPaso => DateTime.now().isAfter(fechaOut);

  @override
  String toString() {
    return 'Reserva{id: $id, habitacion: $idHabitacion, usuario: $mailUsuario, fechaIn: $fechaIn, fechaOut: $fechaOut, estado: $estado}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reserva && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}