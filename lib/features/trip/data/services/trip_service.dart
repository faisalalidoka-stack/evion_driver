import '../models/active_trip.dart';

class TripService {
  Future<ActiveTrip> fetchTrip() async {
    return ActiveTrip.initial();
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