//modelo de habitacion
class Habitacion {
  final String id;
  final int cantidadCamas;
  final String descripcion;
  final double? precioPorNoche; //podria ser útil despues
  final bool? disponible; //podria ser útil despues

  Habitacion({
    required this.id,
    required this.cantidadCamas,
    required this.descripcion,
    this.precioPorNoche,
    this.disponible,
  });

  //constructor desde JSON
  factory Habitacion.fromJson(Map<String, dynamic> json) {
    return Habitacion(
      id: json['id'] as String,
      cantidadCamas: json['cantidad_camas'] as int,
      descripcion: json['descripcion'] as String,
      precioPorNoche: json['precio_por_noche'] != null
          ? (json['precio_por_noche'] as num).toDouble()
          : null,
      disponible: json['disponible'] as bool?,
    );
  }

  //convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidad_camas': cantidadCamas,
      'descripcion': descripcion,
      'precio_por_noche': precioPorNoche,
      'disponible': disponible,
    };
  }

  @override
  String toString() {
    return 'Habitacion{id: $id, cantidadCamas: $cantidadCamas, descripcion: $descripcion, precio: $precioPorNoche, disponible: $disponible}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habitacion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}