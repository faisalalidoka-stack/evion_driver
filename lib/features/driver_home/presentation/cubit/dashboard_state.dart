import '../../data/models/dashboard_data.dart';

class DashboardState {
  final DashboardData data;
  final bool loading;
  final String? error;

  const DashboardState({
    required this.data,
    required this.loading,
    this.error,
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
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}