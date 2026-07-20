import '../entities/trip.dart';

abstract class TripRepository {
  Stream<List<Trip>> watchActiveTrips();
  Stream<Trip> watchTrip(String tripId);
  String generateTripId();
  Future<void> startTrip(Trip trip);
  Future<void> updateTrip(Trip trip);
  Future<void> endTrip(String tripId);
  Future<bool> reserveSeat(String tripId);
}