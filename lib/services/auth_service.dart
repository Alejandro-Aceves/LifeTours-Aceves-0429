import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

/// Servicio de autenticación manual contra Firestore.
/// No utiliza Firebase Authentication.
/// Consulta la colección "usuarios" para validar credenciales.
class AuthService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Usuario actualmente autenticado en sesión.
  Usuario? _usuarioActual;
  Usuario? get usuarioActual => _usuarioActual;

  /// Inicia sesión consultando la colección "usuarios" en Firestore.
  /// Retorna el [Usuario] si las credenciales son válidas.
  /// Lanza una [Exception] si el correo no existe o la contraseña es incorrecta.
  Future<Usuario> iniciarSesion(String correo, String password) async {
    try {
      final query = await _db
          .collection('usuarios')
          .where('correo', isEqualTo: correo.trim().toLowerCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('No existe un usuario con ese correo.');
      }

      final doc = query.docs.first;
      final usuario = Usuario.fromFirestore(doc);

      if (usuario.password != password) {
        throw Exception('Contraseña incorrecta.');
      }

      _usuarioActual = usuario;
      return usuario;
    } on FirebaseException catch (e) {
      throw Exception('Error de Firestore: ${e.message}');
    }
  }

  /// Cierra la sesión actual limpiando el usuario en memoria.
  void cerrarSesion() {
    _usuarioActual = null;
  }
}
