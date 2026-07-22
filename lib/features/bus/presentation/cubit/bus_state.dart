import '../../data/models/bus_model.dart';

class BusState {
  final BusModel bus;
  final bool loading;
  final String? error;

  const BusState({
    required this.bus,
    required this.loading,
    this.error,
  });

  factory BusState.initial() {
    return BusState(
      bus: BusModel.demo(),
      loading: true,
    );
  }

  BusState copyWith({
    BusModel? bus,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return BusState(
      bus: bus ?? this.bus,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}