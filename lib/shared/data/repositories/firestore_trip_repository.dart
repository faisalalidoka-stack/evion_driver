import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/firestore_trip_datasource.dart';
import '../models/trip_model.dart';

class FirestoreTripRepository implements TripRepository {
  FirestoreTripRepository(this.dataSource);

  final FirestoreTripDataSource dataSource;

  @override
  Stream<List<Trip>> watchActiveTrips() {
    return dataSource.trips
        .where('status', whereIn: ['boarding', 'active'])
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TripModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  @override
  Stream<Trip> watchTrip(String tripId) {
    return dataSource.trips
        .doc(tripId)
        .snapshots()
        .map((doc) => TripModel.fromMap(doc.data()!, doc.id));
  }

  @override
  Future<void> startTrip(Trip trip) async {
    final model = TripModel.fromEntity(trip);
    await dataSource.trips.doc(trip.id).set(model.toMap());
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    final model = TripModel.fromEntity(trip);
    await dataSource.trips.doc(trip.id).update(model.toMap());
  }

  @override
  Future<void> endTrip(String tripId) async {
    await dataSource.trips.doc(tripId).update({
      "status": "completed",
      "completedAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  String generateTripId() => dataSource.trips.doc().id;

  @override
  Future<bool> reserveSeat(String tripId) async {
    final docRef = dataSource.trips.doc(tripId);

    return dataSource.firestore.runTransaction<bool>((transaction) async {
      final snapshot = await transaction.get(docRef);
      final seats = (snapshot.data()?['availableSeats'] ?? 0) as int;

      if (seats <= 0) return false;

      transaction.update(docRef, {'availableSeats': seats - 1});
      return true;
    });
  }
}