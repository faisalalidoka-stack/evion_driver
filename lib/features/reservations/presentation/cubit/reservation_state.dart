import '../../data/models/reservation_model.dart';

class ReservationState {
  final List<ReservationModel> reservations;
  final bool loading;

  const ReservationState({
    required this.reservations,
    required this.loading,
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
  }) {
    return ReservationState(
      reservations: reservations ?? this.reservations,
      loading: loading ?? this.loading,
    );
  }
}