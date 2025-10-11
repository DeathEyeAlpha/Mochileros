// lib/models/habitacion.dart

class Habitacion {
  final int numero;
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
    required this.numero,
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
  // Ej.: {numero:1, televisores:2, camas:3, baños:4, descripcion:"...", imagen:"https://...", nombre:null, cuartos:1, precio:null}

  // imagen puede venir como String, List o null -> convertir siempre a List<String>
  List<String> _parseImagenes(dynamic v) {
    if (v == null) return <String>[];
    if (v is List) return v.map((e) => e.toString()).toList();
    return [v.toString()]; // venía un solo string
  }

  double _parseDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  int _parseInt(dynamic v) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  return Habitacion(
    numero:      _parseInt(json['numero']),
    nombre:      (json['nombre'] ?? '').toString(),
    reservas:    _parseInt(json['reservas']),      // si tu RPC no lo devuelve, quedará 0
    imagenes:    _parseImagenes(json['imagen']),
    cuartos:     _parseInt(json['cuartos']),
    camas:       _parseInt(json['camas']),
    televisores: _parseInt(json['televisores']),
    banos:       _parseInt(json['baños']),         // ojo con la tilde: la clave es 'baños'
    precio:      _parseDouble(json['precio']),
    descripcion: (json['descripcion'] ?? '').toString(),
    disponible:  json['disponible'] == true || json['disponible'] == 1,
  );
}

  //convertir el objeto a un mapa, útil para enviar a una base de datos
  Map<String, dynamic> toJson() {
    return {
      'Numero': numero,
      'Nombre': nombre,
      'Reservas': reservas,
      'Imagenes': imagenes,
      'Cuartos': cuartos,
      'Camas': camas,
      'Televisores': televisores,
      'Baños': banos,
      'Precio': precio,
      'Descripcion': descripcion,
      'Disponible': disponible,
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
      numero: numero ?? this.numero,
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