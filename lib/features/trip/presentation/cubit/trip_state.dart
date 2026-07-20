import '../../data/models/trip_model.dart';

enum DriverTripStatus {
  idle,
  starting,
  onTrip,
  ending,
  error,
}

class TripState {
  final DriverTripStatus status;
  final TripModel? trip;
  final String? message;

  const TripState({
    this.status = DriverTripStatus.idle,
    this.trip,
    this.message,
  });

  TripState copyWith({
    DriverTripStatus? status,
    TripModel? trip,
    String? message,
  }) {
    return TripState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      message: message,
    );
  }
}