class RouteModel {
  final String id;
  final String name;
  final String start;
  final String destination;
  final List<String> stopIds;

  const RouteModel({
    required this.id,
    required this.name,
    required this.start,
    required this.destination,
    required this.stopIds,
  });

  int get stopCount => stopIds.length;

  factory RouteModel.demo() {
    return const RouteModel(
      id: "1",
      name: "Kampala → Makerere",
      start: "Kampala",
      destination: "Makerere",
      stopIds: [],
    );
  }

  RouteModel copyWith({
    String? id,
    String? name,
    String? start,
    String? destination,
    List<String>? stopIds,
  }) {
    return RouteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      start: start ?? this.start,
      destination: destination ?? this.destination,
      stopIds: stopIds ?? this.stopIds,
    );
  }
}