import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/route_repository.dart';
import '/features/route/data/route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit(
      this._repository,
      ) : super(RouteState.initial());

  final RouteRepository _repository;

  Future<void> loadRoute(String driverId) async {
    emit(
      state.copyWith(
        loading: true,
      ),
    );

    final route =
    await _repository.getRoute(driverId);

    emit(
      state.copyWith(
        route: route,
        loading: false,
      ),
    );
  }
}