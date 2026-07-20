import 'package:cloud_firestore/cloud_firestore.dart';

class RouteModel {
  final String id;
  final String name;
  final List<GeoPoint> polyline;
  final List<String> stopIds;

  const RouteModel({
    required this.id,
    required this.name,
    required this.polyline,
    required this.stopIds,
  });

  factory RouteModel.fromMap(String id, Map<String, dynamic> map) {
    return RouteModel(
      id: id,
      name: map['name'] ?? '',
      polyline: (map['polyline'] as List<dynamic>? ?? []).cast<GeoPoint>(),
      stopIds: (map['stopIds'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}