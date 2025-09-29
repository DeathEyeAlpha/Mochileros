// lib/models/huesped.dart

import 'usuario.dart';

class Huesped extends Usuario {

  Huesped({
    required String cedula,
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasena,
  }) : super(
          cedula: cedula,
          nombre: nombre,
          apellido: apellido,
          correo: correo,
          contrasena: contrasena,
          isAdmin: false, //porque es huesped
        );

  //constructor desde usuario base
  factory Huesped.fromUsuario(Usuario usuario) {
    if (usuario.isAdmin) {
      throw Exception('El usuario es administrador, no huésped');
    }
    return Huesped(
      cedula: usuario.cedula,
      nombre: usuario.nombre,
      apellido: usuario.apellido,
      correo: usuario.correo,
      contrasena: usuario.contrasena,
    );
  }

  //constructor desde JSON
  factory Huesped.fromJson(Map<String, dynamic> json) {
    return Huesped(
      cedula: json['cedula'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      correo: json['correo'] as String,
      contrasena: json['contrasena'] as String
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }

  @override
  String toString() {
    return 'Huesped{cedula: $cedula, nombre: $nombre, apellido: $apellido, correo: $correo}';
  }
}