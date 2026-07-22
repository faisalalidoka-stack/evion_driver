import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reservation_model.dart';

class ReservationService {
  ReservationService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reservations =>
      _firestore.collection('reservations');

  Stream<List<ReservationModel>> reservations(String driverId) {
    return _reservations
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return ReservationModel(
          id: doc.id,
          passengerName: data['passengerName'],
          seats: data['seats'],
          pickupStop: data['pickupStop'],
          destinationStop: data['destinationStop'],
          status: data['status'] ?? 'confirmed',
          boarded: data['boarded'] ?? false,
        );
      }).toList();
    });
  }

  Future<void> setBoarded(String reservationId, bool boarded) async {
    await _reservations.doc(reservationId).update({'boarded': boarded});
  }
}