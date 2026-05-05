import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String correo;
  final String password;
  final String nombre;

  const Usuario({
    required this.id,
    required this.correo,
    required this.password,
    required this.nombre,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      correo: data['correo'] as String? ?? '',
      password: data['password'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correo': correo,
      'password': password,
      'nombre': nombre,
    };
  }
}
