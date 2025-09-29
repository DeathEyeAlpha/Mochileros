//interface para el servicio de usuario
import '../../models/usuario.dart';

abstract class IUsuarioService {
  //registra un nuevo usuario en el sistema
  //retorna true si el registro fue exitoso, false en caso contrario
  Future<bool> registrarUsuario(Usuario usuario);

  //inicia sesion con correo y contraseña
  //retorna el Usuario si las credenciales son correctas, null en caso contrario
  Future<Usuario?> login(String correo, String contrasena);

  //cierra la sesión del usuario actual
  Future<void> logout();

  //obtiene el usuario actualmente autenticado
  //retorna el usuario si hay sesión activa, null en caso contrario
  Future<Usuario?> getUsuarioActual();
}