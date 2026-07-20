import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus_model.dart';
import '../models/route_model.dart';

class ReferenceDataRepository {
  ReferenceDataRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<RouteModel>> fetchRoutes() async {
    final snapshot = await _firestore.collection('routes').get();
    return snapshot.docs
        .map((doc) => RouteModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<BusModel?> fetchBus(String busId) async {
    final doc = await _firestore.collection('buses').doc(busId).get();
    if (!doc.exists) return null;
    return BusModel.fromMap(doc.id, doc.data()!);
  }
}