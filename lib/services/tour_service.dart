import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tour.dart';

/// Servicio CRUD para la colección "tours" en Firestore.
class TourService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _col;

  TourService() : _col = FirebaseFirestore.instance.collection('tours');

  // ── CREATE ────────────────────────────────────────────────

  Future<void> crearTour(Tour tour) async {
    try {
      await _col.add(tour.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Error al crear tour: ${e.message}');
    }
  }

  // ── READ ──────────────────────────────────────────────────

  /// Devuelve un stream en tiempo real con todos los tours,
  /// ordenados por nombre.
  Stream<List<Tour>> obtenerTours() {
    return _col.orderBy('nombre').snapshots().map(
          (snap) => snap.docs.map((doc) => Tour.fromFirestore(doc)).toList(),
        );
  }

  /// Obtiene un tour por su id.
  Future<Tour?> obtenerTourPorId(String id) async {
    try {
      final doc = await _col.doc(id).get();
      if (!doc.exists) return null;
      return Tour.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw Exception('Error al obtener tour: ${e.message}');
    }
  }

  // ── UPDATE ────────────────────────────────────────────────

  Future<void> actualizarTour(Tour tour) async {
    try {
      await _col.doc(tour.id).update(tour.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Error al actualizar tour: ${e.message}');
    }
  }

  // ── DELETE ────────────────────────────────────────────────

  Future<void> eliminarTour(String id) async {
    try {
      await _col.doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Error al eliminar tour: ${e.message}');
    }
  }
}
