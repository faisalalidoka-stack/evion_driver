import 'package:cloud_firestore/cloud_firestore.dart';

import 'trip_status.dart';

class TripModel {
  final String id;
  final String routeId;
  final String driverId;
  final String busId;
  final GeoPoint currentLocation;
  final int availableSeats;
  final double speed;
  final double heading;
  final TripStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int currentStopIndex;
  final String? currentStopId;
  final DateTime? departedCurrentStopAt;

  const TripModel({
    required this.id,
    required this.routeId,
    required this.driverId,
    required this.busId,
    required this.currentLocation,
    required this.availableSeats,
    required this.speed,
    required this.heading,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.currentStopIndex = -1,
    this.currentStopId,
    this.departedCurrentStopAt,
  });

  factory TripModel.fromMap(String id, Map<String, dynamic> map) {
    return TripModel(
      id: id,
      routeId: map['routeId'] ?? '',
      driverId: map['driverId'] ?? '',
      busId: map['busId'] ?? '',
      currentLocation: map['currentLocation'] as GeoPoint,
      availableSeats: map['availableSeats'] ?? 0,
      speed: (map['speed'] ?? 0).toDouble(),
      heading: (map['heading'] ?? 0).toDouble(),
      status: TripStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => TripStatus.scheduled,
      ),
      startedAt: (map['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
      currentStopIndex: map['currentStopIndex'] ?? -1,
      currentStopId: map['currentStopId'],
      departedCurrentStopAt:
      (map['departedCurrentStopAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'driverId': driverId,
      'busId': busId,
      'currentLocation': currentLocation,
      'availableSeats': availableSeats,
      'speed': speed,
      'heading': heading,
      'status': status.name,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt':
      completedAt == null ? null : Timestamp.fromDate(completedAt!),
      'currentStopIndex': currentStopIndex,
      'currentStopId': currentStopId,
      'departedCurrentStopAt': departedCurrentStopAt == null
          ? null
          : Timestamp.fromDate(departedCurrentStopAt!),
    };
  }
}