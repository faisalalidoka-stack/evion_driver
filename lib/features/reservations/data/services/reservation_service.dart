import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reservation_model.dart';
import '../models/reservation_status.dart';

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
          pickupStopId: data['pickupStopId'] ?? '',
          pickupStopName: data['pickupStopName'] ?? '',
          destinationStopId: data['destinationStopId'] ?? '',
          destinationStopName: data['destinationStopName'] ?? '',
          status: ReservationStatus.fromString(data['status']),
        );
      }).toList();
    });
  }

  Future<void> updateStatus(String reservationId, ReservationStatus status) async {
    await _reservations.doc(reservationId).update({'status': status.firestoreValue});
  }

  Future<void> completeReservations(List<String> ids) async {
    if (ids.isEmpty) return;

    final batch = _firestore.batch();
    for (final id in ids) {
      batch.update(_reservations.doc(id), {
        'status': ReservationStatus.completed.firestoreValue,
      });
    }
    await batch.commit();
  }
}