// lib/models/habitacion.dart

class Habitacion {
  final String id;
  final String nombre;
  final int reservas;
  final List<String> imagenes;
  final int cuartos;
  final int camas;
  final int televisores;
  final int banos;
  final double precio;
  final String descripcion;
  final bool? disponible; 

  Habitacion({
    required this.id,
    required this.nombre,
    this.reservas = 0, //una habitación nueva no tiene reservas
    required this.imagenes,
    required this.cuartos,
    required this.camas,
    required this.televisores,
    required this.banos,
    required this.precio,
    required this.descripcion,
    this.disponible,
  });

  //aun no lo usamos, pero es bueno tenerlo para el futuro
  factory Habitacion.fromJson(Map<String, dynamic> json) {
    return Habitacion(
      id: json['id'],
      nombre: json['nombre'],
      reservas: json['reservas'],
      //esto se asegura que se lean las imagenes como lista de strings
      imagenes: List<String>.from(json['imagenes']), 
      cuartos: json['cuartos'],
      camas: json['camas'],
      televisores: json['televisores'],
      banos: json['banos'],
      precio: (json['precio'] as num).toDouble(),
      descripcion: json['descripcion'],
      disponible: json['disponible'],
    );
  }

  //convertir el objeto a un mapa, útil para enviar a una base de datos
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'reservas': reservas,
      'imagenes': imagenes,
      'cuartos': cuartos,
      'camas': camas,
      'televisores': televisores,
      'banos': banos,
      'precio': precio,
      'descripcion': descripcion,
      'disponible': disponible,
    };
  }

  Habitacion copyWith({
    String? id,
    String? nombre,
    int? reservas,
    List<String>? imagenes,
    int? cuartos,
    int? camas,
    int? televisores,
    int? banos,
    double? precio,
    String? descripcion,
    bool? disponible,
  }) {
    return Habitacion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      reservas: reservas ?? this.reservas,
      imagenes: imagenes ?? this.imagenes,
      cuartos: cuartos ?? this.cuartos,
      camas: camas ?? this.camas,
      televisores: televisores ?? this.televisores,
      banos: banos ?? this.banos,
      precio: precio ?? this.precio,
      descripcion: descripcion ?? this.descripcion,
      disponible: disponible ?? this.disponible,
    );
  }
}