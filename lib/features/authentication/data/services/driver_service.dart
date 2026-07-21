import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver_model.dart';

class DriverService {
  DriverService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<DriverModel> getDriver(String uid) async {
    final doc = await _firestore
        .collection('drivers')
        .doc(uid)
        .get();

    if (!doc.exists) {
      throw Exception("Driver profile not found.");
    }

    return DriverModel.fromMap(
      uid,
      doc.data()!,
    );
  }

  Future<void> updateOnlineStatus({
    required String uid,
    required bool online,
  }) async {
    await _firestore.collection('drivers').doc(uid).update({
      'online': online,
    });
  }
}