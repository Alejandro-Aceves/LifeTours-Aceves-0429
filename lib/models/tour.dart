import 'package:cloud_firestore/cloud_firestore.dart';

class Tour {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String duracion;

  const Tour({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracion,
  });

  factory Tour.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tour(
      id: doc.id,
      nombre: data['nombre'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0.0,
      duracion: data['duracion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'duracion': duracion,
    };
  }

  Tour copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precio,
    String? duracion,
  }) {
    return Tour(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      duracion: duracion ?? this.duracion,
    );
  }
}
