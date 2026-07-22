import '../models/bus_model.dart';
import '../services/bus_service.dart';

class BusRepository {
  BusRepository({
    BusService? service,
  }) : _service = service ?? BusService();

  final BusService _service;

  Future<String> getAssignedBusId(String driverId) {
    return _service.getAssignedBusId(driverId);
  }

  Stream<BusModel> watchBus(String busId) {
    return _service.watchBus(busId);
  }

  Future<void> resetAvailableSeats(String busId, int totalSeats) {
    return _service.resetAvailableSeats(busId, totalSeats);
  }
}