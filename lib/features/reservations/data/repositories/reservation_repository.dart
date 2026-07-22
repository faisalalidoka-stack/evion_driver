import '../models/reservation_model.dart';
import '../models/reservation_status.dart';
import '../services/reservation_service.dart';

class ReservationRepository {
  ReservationRepository({
    ReservationService? service,
  }) : _service = service ?? ReservationService();

  final ReservationService _service;

  Stream<List<ReservationModel>> reservations(String driverId) {
    return _service.reservations(driverId);
  }

  Future<void> updateStatus(String reservationId, ReservationStatus status) {
    return _service.updateStatus(reservationId, status);
  }
  Future<void> completeReservations(List<String> ids) {
    return _service.completeReservations(ids);
  }
}