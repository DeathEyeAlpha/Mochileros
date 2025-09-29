//modelo de usuario
class Usuario {
  final String cedula;
  final String nombre;
  final String apellido;
  final String correo;
  final String contrasena;
  final bool isAdmin;

  Usuario({
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.contrasena,
    required this.isAdmin,
  });

  //constructor para crear desde JSON, se usa para APIs
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      cedula: json['cedula'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      correo: json['correo'] as String,
      contrasena: json['contrasena'] as String,
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }

  //metodo para convertir a JSON, se usa para enviar a APIs
  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'contrasena': contrasena,
      'is_admin': isAdmin,
    };
  }

  @override
  String toString() {
    return 'Usuario{cedula: $cedula, nombre: $nombre, apellido: $apellido, correo: $correo, isAdmin: $isAdmin}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario && other.cedula == cedula;
  }

  @override
  int get hashCode => cedula.hashCode;
}