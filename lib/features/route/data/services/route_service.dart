import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/route_model.dart';

class RouteService {
  RouteService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<RouteModel> fetchRoute(String driverId) async {
    final driverDoc =
    await _firestore.collection('drivers').doc(driverId).get();

    if (!driverDoc.exists) {
      throw Exception("Driver not found.");
    }

    final routeId = driverDoc['routeId'];

    final routeDoc =
    await _firestore.collection('routes').doc(routeId).get();

    if (!routeDoc.exists) {
      throw Exception("Route not found.");
    }

    final data = routeDoc.data()!;

    return RouteModel(
      id: routeDoc.id,
      name: data['name'],
      start: data['start'],
      destination: data['destination'],
      stopIds: List<String>.from(data['stopIds'] ?? const []),
    );
  }
}