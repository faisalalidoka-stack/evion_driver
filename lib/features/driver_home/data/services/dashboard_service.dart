import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dashboard_data.dart';
import '../models/driver_status.dart';

class DashboardService {
  DashboardService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<DashboardData> fetchDashboard(String driverId) async {
    final driverDoc =
    await _firestore.collection('drivers').doc(driverId).get();

    if (!driverDoc.exists) {
      throw Exception("Driver not found.");
    }

    final data = driverDoc.data()!;

    return DashboardData(
      driverName: data['name'] ?? "",
      online: data['online'] ?? false,
      driverStatus:
      (data['online'] ?? false) ? DriverStatus.online : DriverStatus.offline,
      busCode: "",
      busCapacity: 0,
      routeName: "",
      stopCount: 0,
      tripStatus: "Not Started",
      reservations: 0,
    );
  }

  Future<void> updateOnlineStatus({
    required String driverId,
    required bool online,
  }) async {
    await _firestore.collection('drivers').doc(driverId).update({
      "online": online,
    });
  }
}