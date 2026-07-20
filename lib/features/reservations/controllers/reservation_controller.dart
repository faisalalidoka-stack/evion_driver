import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../shared/data/dummy_bus_stops.dart';
import '../../../shared/domain/entities/reservation.dart';
import '../../../shared/domain/entities/trip.dart';
import '../../../shared/domain/enums/reservation_status.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../authentication/providers/auth_providers.dart';
import '../../home/domain/entities/bus_stop.dart';
import '../domain/reservation_state.dart';

class ReservationController extends StateNotifier<ReservationState> {
  ReservationController(this._ref) : super(const ReservationState());

  final Ref _ref;

  void selectJourney({
    required Trip trip,
    required BusStop destination,
  }) {
    state = state.copyWith(
      selectedTrip: trip,
      destination: destination,
      status: ReservationFlowStatus.selected,
    );
  }

  /// Reserves a seat on an already-running trip (started by the driver
  /// app) instead of inventing one, and reserves atomically so two
  /// passengers can't both grab the last seat.
  Future<void> confirmReservation() async {
    final trip = state.selectedTrip;
    final destination = state.destination;

    if (trip == null || destination == null) return;

    final passengerId = _ref.read(authControllerProvider).user?.id;

    if (passengerId == null) {
      state = state.copyWith(
        errorMessage: 'You need to be signed in to reserve a seat.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final tripRepository = _ref.read(tripRepositoryProvider);
      final reservationRepository = _ref.read(reservationRepositoryProvider);

      final seatReserved = await tripRepository.reserveSeat(trip.id);

      if (!seatReserved) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'That bus just filled up. Please choose another.',
        );
        return;
      }

      final reservation = Reservation(
        id: '',
        passengerId: passengerId,
        tripId: trip.id,
        // No pickup-stop picker exists yet — placeholder until that
        // UI gets built.
        pickupStopId: dummyBusStops.first.id,
        destinationStopId: destination.id,
        status: ReservationStatus.accepted,
      );

      final reservationId = await reservationRepository.create(reservation);

      state = state.copyWith(
        status: ReservationFlowStatus.confirmed,
        reservationId: reservationId,
        isSubmitting: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Could not complete your reservation. Please try again.',
      );
    }
  }

  Future<void> completeTrip() async {
    final reservationId = state.reservationId;

    if (reservationId != null) {
      await _ref
          .read(reservationRepositoryProvider)
          .updateStatus(reservationId, ReservationStatus.completed);
    }

    state = state.copyWith(status: ReservationFlowStatus.completed);
  }

  void clear() {
    state = const ReservationState();
  }
}

final reservationControllerProvider =
StateNotifierProvider<ReservationController, ReservationState>(
      (ref) => ReservationController(ref),
);