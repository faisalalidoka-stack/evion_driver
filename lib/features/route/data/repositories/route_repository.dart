import '../models/route_model.dart';
import '../services/route_service.dart';

class RouteRepository {
  RouteRepository({
    RouteService? service,
  }) : _service = service ?? RouteService();

  final RouteService _service;

  Future<RouteModel> getRoute(String driverId) {
    return _service.fetchRoute(driverId);
  }
}