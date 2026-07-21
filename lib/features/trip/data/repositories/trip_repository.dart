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
}