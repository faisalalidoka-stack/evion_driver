import '../../data/models/bus_model.dart';

class BusState {
  final BusModel bus;
  final bool loading;

  const BusState({
    required this.bus,
    required this.loading,
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
  }) {
    return BusState(
      bus: bus ?? this.bus,
      loading: loading ?? this.loading,
    );
  }
}