import '../../data/models/active_trip.dart';

class TripState {
  final ActiveTrip trip;

  const TripState({
    required this.trip,
  });

  factory TripState.initial() {
    return TripState(
      trip: ActiveTrip.initial(),
    );
  }

  TripState copyWith({
    ActiveTrip? trip,
  }) {
    return TripState(
      trip: trip ?? this.trip,
    );
  }
}