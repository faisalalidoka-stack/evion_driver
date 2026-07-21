import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/bus_repository.dart';
import 'bus_state.dart';

class BusCubit extends Cubit<BusState> {
  BusCubit(
      this._repository,
      ) : super(BusState.initial());

  final BusRepository _repository;

  Future<void> loadBus(String driverId) async {
    emit(
      state.copyWith(
        loading: true,
      ),
    );

    final bus =
    await _repository.getBus(driverId);

    emit(
      state.copyWith(
        bus: bus,
        loading: false,
      ),
    );
  }
}