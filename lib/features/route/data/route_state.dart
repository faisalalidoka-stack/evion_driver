import 'models/route_model.dart';

class RouteState {
  final RouteModel route;
  final bool loading;

  const RouteState({
    required this.route,
    required this.loading,
  });

  factory RouteState.initial() {
    return RouteState(
      route: RouteModel.demo(),
      loading: true,
    );
  }

  RouteState copyWith({
    RouteModel? route,
    bool? loading,
  }) {
    return RouteState(
      route: route ?? this.route,
      loading: loading ?? this.loading,
    );
  }
}