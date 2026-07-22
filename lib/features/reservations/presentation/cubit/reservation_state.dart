import '../../data/models/reservation_model.dart';

class ReservationState {
  final List<ReservationModel> reservations;
  final bool loading;
  final String? error;

  const ReservationState({
    required this.reservations,
    required this.loading,
    this.error,
  });

  factory ReservationState.initial() {
    return ReservationState(
      reservations: const [],
      loading: true,
    );
  }

  ReservationState copyWith({
    List<ReservationModel>? reservations,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return ReservationState(
      reservations: reservations ?? this.reservations,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}