import '../models/stop_model.dart';
import '../services/stop_service.dart';

class StopRepository {
  StopRepository({StopService? service}) : _service = service ?? StopService();

  final StopService _service;

  Future<List<StopModel>> getStops(List<String> stopIds) {
    return _service.fetchStops(stopIds);
  }

  Future<StopModel?> getStop(String stopId) {
    return _service.fetchStop(stopId);
  }
}