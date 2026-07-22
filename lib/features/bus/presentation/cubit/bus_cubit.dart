import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/bus_repository.dart';
import 'bus_state.dart';

class BusCubit extends Cubit<BusState> {
  BusCubit(this._repository) : super(BusState.initial());

  final BusRepository _repository;
  StreamSubscription? _subscription;

  Future<void> loadBus(String driverId) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final busId = await _repository.getAssignedBusId(driverId);

      _subscription?.cancel();
      _subscription = _repository.watchBus(busId).listen(
            (bus) {
          emit(state.copyWith(bus: bus, loading: false));
        },
        onError: (e) {
          emit(state.copyWith(loading: false, error: e.toString()));
        },
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> resetSeats() async {
    try {
      await _repository.resetAvailableSeats(state.bus.id, state.bus.totalSeats);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}