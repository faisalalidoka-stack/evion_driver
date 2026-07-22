import '../models/trip_model.dart';
import '../services/trip_service.dart';

class TripRepository {
  TripRepository({TripService? service}) : _service = service ?? TripService();

  final TripService _service;

  Stream<TripModel?> watchActiveTrip(String driverId) {
    return _service.watchActiveTrip(driverId);
  }

  Future<void> startTrip({
    required String driverId,
    required String busId,
    required String routeId,
    required int availableSeats,
  }) {
    return _service.startTrip(
      driverId: driverId,
      busId: busId,
      routeId: routeId,
      availableSeats: availableSeats,
    );
  }

  Future<void> endTrip(String tripId) {
    return _service.endTrip(tripId);
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
  Future<void> advanceStop(String tripId, String stopId, int stopIndex) {
    return _service.advanceStop(tripId, stopId, stopIndex);
  }
}