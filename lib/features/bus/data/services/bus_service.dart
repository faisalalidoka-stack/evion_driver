import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus_model.dart';

class BusService {
  BusService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<BusModel> fetchBus(String driverId) async {
    final driverDoc =
    await _firestore.collection('drivers').doc(driverId).get();

    if (!driverDoc.exists) {
      throw Exception("Driver not found.");
    }

    final busId = driverDoc['busId'];

    final busDoc =
    await _firestore.collection('buses').doc(busId).get();

    if (!busDoc.exists) {
      throw Exception("Bus not found.");
    }

    final data = busDoc.data()!;

    return BusModel(
      id: busDoc.id,
      code: data['code'],
      registration: data['registration'],
      totalSeats: data['totalSeats'],
      availableSeats: data['availableSeats'],
      active: data['active'],
    );
  }
}