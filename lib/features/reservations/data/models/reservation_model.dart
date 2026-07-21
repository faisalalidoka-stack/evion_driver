class ReservationModel {
  final String id;
  final String passengerName;
  final int seats;
  final String pickupStop;
  final String destinationStop;
  final bool boarded;

  const ReservationModel({
    required this.id,
    required this.passengerName,
    required this.seats,
    required this.pickupStop,
    required this.destinationStop,
    required this.boarded,
  });

  factory ReservationModel.demo() {
    return const ReservationModel(
      id: "1",
      passengerName: "Faisal Ali",
      seats: 1,
      pickupStop: "Wandegeya",
      destinationStop: "Makerere",
      boarded: false,
    );
  }
}