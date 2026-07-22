import 'reservation_status.dart';

class ReservationModel {
  final String id;
  final String passengerName;
  final int seats;
  final String pickupStopId;
  final String pickupStopName;
  final String destinationStopId;
  final String destinationStopName;
  final ReservationStatus status;

  const ReservationModel({
    required this.id,
    required this.passengerName,
    required this.seats,
    required this.pickupStopId,
    required this.pickupStopName,
    required this.destinationStopId,
    required this.destinationStopName,
    required this.status,
  });

  bool get isReserved => status == ReservationStatus.reserved;
  bool get isBoardingSoon => status == ReservationStatus.boardingSoon;
  bool get isAwaitingBoarding => status == ReservationStatus.awaitingBoarding;
  bool get isBoarded => status == ReservationStatus.boarded;
  bool get isMissed => status == ReservationStatus.missed;
  bool get isCancelled => status == ReservationStatus.cancelled;
  bool get isCompleted => status == ReservationStatus.completed;

  factory ReservationModel.demo() {
    return const ReservationModel(
      id: "1",
      passengerName: "Faisal Ali",
      seats: 1,
      pickupStopId: "stop_1",
      pickupStopName: "Wandegeya",
      destinationStopId: "stop_9",
      destinationStopName: "Makerere",
      status: ReservationStatus.reserved,
    );
  }
}