import '../../data/models/dashboard_data.dart';

class DashboardState {
  final DashboardData data;
  final bool loading;

  const DashboardState({
    required this.data,
    required this.loading,
  });

  factory DashboardState.initial() {
    return DashboardState(
      data: DashboardData.demo(),
      loading: true,
    );
  }

  DashboardState copyWith({
    DashboardData? data,
    bool? loading,
  }) {
    return DashboardState(
      data: data ?? this.data,
      loading: loading ?? false,
    );
  }
}