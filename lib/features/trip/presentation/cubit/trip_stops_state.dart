import '../../../stops/data/models/stop_model.dart';

class TripStopsState {
  final List<StopModel> stops;
  final bool loading;
  final String? error;

  const TripStopsState({
    required this.stops,
    required this.loading,
    this.error,
  });

  factory TripStopsState.initial() {
    return const TripStopsState(stops: [], loading: true);
  }

  TripStopsState copyWith({
    List<StopModel>? stops,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return TripStopsState(
      stops: stops ?? this.stops,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}