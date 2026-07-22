import '../models/reservation_model.dart';
import '../services/reservation_service.dart';

class ReservationRepository {
  ReservationRepository({
    ReservationService? service,
  }) : _service = service ?? ReservationService();

  final ReservationService _service;

  Stream<List<ReservationModel>> reservations(String driverId) {
    return _service.reservations(driverId);
  }

  Future<void> setBoarded(String reservationId, bool boarded) {
    return _service.setBoarded(reservationId, boarded);
  }
}