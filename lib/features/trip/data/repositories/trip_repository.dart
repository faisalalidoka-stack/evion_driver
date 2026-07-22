import '../models/active_trip.dart';
import '../services/trip_service.dart';

class TripRepository {
  TripRepository({
    TripService? service,
  }) : _service = service ?? TripService();

  final TripService _service;

  Future<ActiveTrip> getTrip() {
    return _service.fetchTrip();
  }
  Future<void> updateLocation(
      String tripId, {
        required double latitude,
        required double longitude,
        required double speed,
        required double heading,
      }) {
    return _service.updateLocation(
      tripId,
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      heading: heading,
    );
  }
}