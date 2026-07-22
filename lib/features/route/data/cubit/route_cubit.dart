import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/route_repository.dart';
import '/features/route/data/route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit(this._repository) : super(RouteState.initial());

  final RouteRepository _repository;

  Future<void> loadRoute(String driverId) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final route = await _repository.getRoute(driverId);
      emit(state.copyWith(route: route, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}