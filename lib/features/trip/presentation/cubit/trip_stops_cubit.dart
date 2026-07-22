import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../stops/data/repositories/stop_repository.dart';
import 'trip_stops_state.dart';

class TripStopsCubit extends Cubit<TripStopsState> {
  TripStopsCubit(this._repository) : super(TripStopsState.initial());

  final StopRepository _repository;

  Future<void> loadStops(List<String> stopIds) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final stops = await _repository.getStops(stopIds);
      emit(state.copyWith(stops: stops, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}