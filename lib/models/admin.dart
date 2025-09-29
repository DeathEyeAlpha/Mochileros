//modelo para admin, hereda de usuario
import 'usuario.dart';

class Admin extends Usuario {

  Admin({
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
          isAdmin: true, //porque es admin
        );

  //constructor desde Usuario base
  factory Admin.fromUsuario(Usuario usuario) {
    if (!usuario.isAdmin) {
      throw Exception('El usuario no es administrador');
    }
    return Admin(
      cedula: usuario.cedula,
      nombre: usuario.nombre,
      apellido: usuario.apellido,
      correo: usuario.correo,
      contrasena: usuario.contrasena,
    );
  }

  //constructor desde JSON
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
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
    return 'Admin{cedula: $cedula, nombre: $nombre, apellido: $apellido, correo: $correo}';
  }
}