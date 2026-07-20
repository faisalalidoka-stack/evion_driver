import '../../../shared/domain/entities/trip.dart';
import '../../home/domain/entities/bus_stop.dart';

enum ReservationFlowStatus {
  idle,
  selected,
  confirmed,
  travelling,
  completed,
}

class ReservationState {
  final Trip? selectedTrip;
  final BusStop? destination;
  final ReservationFlowStatus status;
  final String? reservationId;
  final bool isSubmitting;
  final String? errorMessage;

  const ReservationState({
    this.selectedTrip,
    this.destination,
    this.status = ReservationFlowStatus.idle,
    this.reservationId,
    this.isSubmitting = false,
    this.errorMessage,
  });

  ReservationState copyWith({
    Trip? selectedTrip,
    BusStop? destination,
    ReservationFlowStatus? status,
    String? reservationId,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return ReservationState(
      selectedTrip: selectedTrip ?? this.selectedTrip,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      reservationId: reservationId ?? this.reservationId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}