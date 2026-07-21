import 'driver_status.dart';

class DashboardData {
  final String driverName;
  final bool online;

  final String busCode;
  final int busCapacity;

  final String routeName;
  final int stopCount;

  final String tripStatus;

  final int reservations;

  final DriverStatus driverStatus;

  const DashboardData({
    required this.driverName,
    required this.online,
    required this.busCode,
    required this.busCapacity,
    required this.routeName,
    required this.stopCount,
    required this.tripStatus,
    required this.reservations,
    required this.driverStatus,
  });

  factory DashboardData.demo() {
    return const DashboardData(
      driverName: "John Driver",
      online: true,
      busCode: "EV-001",
      busCapacity: 30,
      routeName: "Kampala → Makerere",
      stopCount: 18,
      tripStatus: "Not Started",
      reservations: 0,
      driverStatus: DriverStatus.ready,
    );
  }
  DashboardData copyWith({
    String? driverName,
    bool? online,
    String? busCode,
    int? busCapacity,
    String? routeName,
    int? stopCount,
    String? tripStatus,
    int? reservations,
    DriverStatus? driverStatus,
  }) {
    return DashboardData(
      driverName: driverName ?? this.driverName,
      online: online ?? this.online,
      busCode: busCode ?? this.busCode,
      busCapacity: busCapacity ?? this.busCapacity,
      routeName: routeName ?? this.routeName,
      stopCount: stopCount ?? this.stopCount,
      tripStatus: tripStatus ?? this.tripStatus,
      reservations: reservations ?? this.reservations,
      driverStatus: driverStatus ?? this.driverStatus,
    );
  }
}