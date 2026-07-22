import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus_model.dart';

class BusService {
  BusService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _buses =>
      _firestore.collection('buses');

  Future<String> getAssignedBusId(String driverId) async {
    final driverDoc =
    await _firestore.collection('drivers').doc(driverId).get();

    if (!driverDoc.exists) {
      throw Exception("Driver not found.");
    }

    final busId = driverDoc['busId'];
    if (busId == null || (busId as String).isEmpty) {
      throw Exception("No bus assigned to this driver.");
    }

    return busId;
  }

  Stream<BusModel> watchBus(String busId) {
    return _buses.doc(busId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception("Bus not found.");
      }

      final data = doc.data()!;

      return BusModel(
        id: doc.id,
        code: data['code'],
        registration: data['registration'],
        totalSeats: data['totalSeats'],
        availableSeats: data['availableSeats'],
        active: data['active'],
      );
    });
  }

  Future<void> resetAvailableSeats(String busId, int totalSeats) async {
    await _buses.doc(busId).update({'availableSeats': totalSeats});
  }
}