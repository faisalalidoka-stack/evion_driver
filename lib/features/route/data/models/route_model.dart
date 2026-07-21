class RouteModel {
  final String id;
  final String name;
  final String start;
  final String destination;
  final int stopCount;

  const RouteModel({
    required this.id,
    required this.name,
    required this.start,
    required this.destination,
    required this.stopCount,
  });

  factory RouteModel.demo() {
    return const RouteModel(
      id: "1",
      name: "Kampala → Makerere",
      start: "Kampala",
      destination: "Makerere",
      stopCount: 18,
    );
  }

  RouteModel copyWith({
    String? id,
    String? name,
    String? start,
    String? destination,
    int? stopCount,
  }) {
    return RouteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      start: start ?? this.start,
      destination: destination ?? this.destination,
      stopCount: stopCount ?? this.stopCount,
    );
  }
}