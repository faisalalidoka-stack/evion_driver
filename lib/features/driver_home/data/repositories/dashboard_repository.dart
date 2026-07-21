import '../models/dashboard_data.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  DashboardRepository({
    DashboardService? service,
  }) : _service = service ?? DashboardService();

  final DashboardService _service;

  Future<DashboardData> getDashboard(
      String driverId,
      ) {
    return _service.fetchDashboard(driverId);
  }

  Future<void> updateOnlineStatus({
    required String driverId,
    required bool online,
  }) {
    return _service.updateOnlineStatus(
      driverId: driverId,
      online: online,
    );
  }
}