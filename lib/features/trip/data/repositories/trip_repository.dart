import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trip_model.dart';
import '../models/trip_status.dart';

class TripRepository {
  TripRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _trips =>
      _firestore.collection('trips');

  String generateTripId() => _trips.doc().id;

  Future<void> startTrip(TripModel trip) async {
    await _trips.doc(trip.id).set(trip.toMap());
  }

  Future<void> updateLocation(
      String tripId, {
        required GeoPoint location,
        required double speed,
        required double heading,
      }) async {
    await _trips.doc(tripId).update({
      'currentLocation': location,
      'speed': speed,
      'heading': heading,
      'status': TripStatus.active.name,
    });
  }

  Future<void> endTrip(String tripId) async {
    await _trips.doc(tripId).update({
      'status': TripStatus.completed.name,
      'completedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}