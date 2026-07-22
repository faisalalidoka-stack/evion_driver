import 'models/route_model.dart';

class RouteState {
  final RouteModel route;
  final bool loading;
  final String? error;

  const RouteState({
    required this.route,
    required this.loading,
    this.error,
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
    String? error,
    bool clearError = false,
  }) {
    return RouteState(
      route: route ?? this.route,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}