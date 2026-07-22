import '../../data/models/trip_model.dart';

class TripState {
  final TripModel? trip;
  final bool loading;
  final String? error;

  const TripState({
    required this.trip,
    required this.loading,
    this.error,
  });

  factory TripState.initial() {
    return const TripState(trip: null, loading: true);
  }

  TripState copyWith({
    TripModel? trip,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return TripState(
      trip: trip ?? this.trip,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}