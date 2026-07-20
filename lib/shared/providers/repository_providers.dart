import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/firestore_reservation_datasource.dart';
import '../data/datasources/firestore_trip_datasource.dart';
import '../data/repositories/firestore_reservation_repository.dart';
import '../data/repositories/firestore_trip_repository.dart';
import '../domain/entities/trip.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final tripRepositoryProvider = Provider(
      (ref) => FirestoreTripRepository(
    FirestoreTripDataSource(ref.watch(firestoreProvider)),
  ),
);

final reservationRepositoryProvider = Provider(
      (ref) => FirestoreReservationRepository(
    FirestoreReservationDataSource(ref.watch(firestoreProvider)),
  ),
);

final activeTripsProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(tripRepositoryProvider).watchActiveTrips();
});