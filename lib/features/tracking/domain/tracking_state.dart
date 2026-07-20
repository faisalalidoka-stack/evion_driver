import '../../../shared/domain/entities/trip.dart';

class TrackingState {
  final Trip? trip;
  final bool isRunning;

  const TrackingState({this.trip, this.isRunning = false});

  TrackingState copyWith({Trip? trip, bool? isRunning}) {
    return TrackingState(
      trip: trip ?? this.trip,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}