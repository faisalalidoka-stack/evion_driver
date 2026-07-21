import '../models/bus_model.dart';
import '../services/bus_service.dart';

class BusRepository {
  BusRepository({
    BusService? service,
  }) : _service = service ?? BusService();

  final BusService _service;

  Future<BusModel> getBus(String driverId) {
    return _service.fetchBus(driverId);
  }
}