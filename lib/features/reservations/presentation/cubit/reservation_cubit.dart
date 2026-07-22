import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/reservation_model.dart';
import '../../data/models/reservation_status.dart';
import '../../data/repositories/reservation_repository.dart';
import 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit(this._repository) : super(ReservationState.initial());

  final ReservationRepository _repository;

  StreamSubscription? _subscription;

  void listenReservations(String driverId) {
    emit(state.copyWith(loading: true, clearError: true));

    _subscription?.cancel();
    _subscription = _repository.reservations(driverId).listen(
          (reservations) {
        emit(state.copyWith(reservations: reservations, loading: false));
      },
      onError: (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      },
    );
  }

  Future<void> confirmBoarding(ReservationModel reservation) {
    if (!reservation.isAwaitingBoarding) return Future.value();
    return _repository.updateStatus(reservation.id, ReservationStatus.boarded);
  }

  Future<void> completeBoardedReservations() async {
    final boardedIds =
    state.reservations.where((r) => r.isBoarded).map((r) => r.id).toList();

    if (boardedIds.isEmpty) return;

    await _repository.completeReservations(boardedIds);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}