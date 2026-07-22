class StopModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const StopModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory StopModel.fromMap(String id, Map<String, dynamic> map) {
    return StopModel(
      id: id,
      name: map['name'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
    );
  }
}