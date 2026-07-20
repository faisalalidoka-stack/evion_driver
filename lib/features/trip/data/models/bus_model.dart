class BusModel {
  final String id;
  final String plateNumber;
  final String fleetNumber;
  final int capacity;

  const BusModel({
    required this.id,
    required this.plateNumber,
    required this.fleetNumber,
    required this.capacity,
  });

  factory BusModel.fromMap(String id, Map<String, dynamic> map) {
    return BusModel(
      id: id,
      plateNumber: map['plateNumber'] ?? '',
      fleetNumber: map['fleetNumber'] ?? '',
      capacity: map['capacity'] ?? 0,
    );
  }
}