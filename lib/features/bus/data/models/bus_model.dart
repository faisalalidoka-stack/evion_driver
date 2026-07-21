class BusModel {
  final String id;
  final String code;
  final String registration;
  final int totalSeats;
  final int availableSeats;
  final bool active;

  const BusModel({
    required this.id,
    required this.code,
    required this.registration,
    required this.totalSeats,
    required this.availableSeats,
    required this.active,
  });

  factory BusModel.demo() {
    return const BusModel(
      id: "1",
      code: "EV-001",
      registration: "UBQ 001E",
      totalSeats: 30,
      availableSeats: 30,
      active: true,
    );
  }

  BusModel copyWith({
    String? id,
    String? code,
    String? registration,
    int? totalSeats,
    int? availableSeats,
    bool? active,
  }) {
    return BusModel(
      id: id ?? this.id,
      code: code ?? this.code,
      registration: registration ?? this.registration,
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      active: active ?? this.active,
    );
  }
}