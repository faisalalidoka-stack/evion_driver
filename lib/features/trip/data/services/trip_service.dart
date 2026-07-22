import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trip_model.dart';
import '../models/trip_status.dart';

class TripService {
  TripService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _trips =>
      _firestore.collection('trips');

  Stream<TripModel?> watchActiveTrip(String driverId) {
    return _trips
        .where('driverId', isEqualTo: driverId)
        .where('status', whereIn: [
      TripStatus.scheduled.name,
      TripStatus.boarding.name,
      TripStatus.active.name,
    ])
        .orderBy('startedAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return TripModel.fromMap(doc.id, doc.data());
    });
  }

  Future<void> startTrip({
    required String driverId,
    required String busId,
    required String routeId,
    required int availableSeats,
  }) async {
    await _trips.add({
      'routeId': routeId,
      'driverId': driverId,
      'busId': busId,
      'currentLocation': const GeoPoint(0, 0),
      'availableSeats': availableSeats,
      'speed': 0.0,
      'heading': 0.0,
      'status': TripStatus.active.name,
      'startedAt': Timestamp.now(),
      'completedAt': null,
      'currentStopIndex': -1,
      'currentStopId': null,
      'departedCurrentStopAt': null,
    });
  }

  Future<void> advanceStop(String tripId, String stopId, int stopIndex) async {
    await _trips.doc(tripId).update({
      'currentStopId': stopId,
      'currentStopIndex': stopIndex,
      'departedCurrentStopAt': Timestamp.now(),
    });
  }

  Future<void> endTrip(String tripId) async {
    await _trips.doc(tripId).update({
      'status': TripStatus.completed.name,
      'completedAt': Timestamp.now(),
    });
  }

  Future<void> updateLocation(
      String tripId, {
        required double latitude,
        required double longitude,
        required double speed,
        required double heading,
      }) async {
    await _trips.doc(tripId).update({
      'currentLocation': GeoPoint(latitude, longitude),
      'speed': speed,
      'heading': heading,
    });
  }

}
