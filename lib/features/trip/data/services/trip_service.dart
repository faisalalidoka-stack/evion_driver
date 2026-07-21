import '../models/active_trip.dart';

class TripService {
  Future<ActiveTrip> fetchTrip() async {
    return ActiveTrip.initial();
  }
}