import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/trip_repository.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit(
      this._repository,
      ) : super(TripState.initial());

  final TripRepository _repository;

  Future<void> loadTrip() async {
    final trip = await _repository.getTrip();

    emit(
      state.copyWith(
        trip: trip,
      ),
    );
  }

  void startTrip() {
    emit(
      state.copyWith(
        trip: state.trip.copyWith(
          active: true,
          status: "In Progress",
          startTime: DateTime.now(),
          endTime: null,
        ),
      ),
    );
  }

  void endTrip() {
    emit(
      state.copyWith(
        trip: state.trip.copyWith(
          active: false,
          status: "Completed",
          endTime: DateTime.now(),
        ),
      ),
    );
  }
}