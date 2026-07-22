enum ReservationStatus {
  reserved,
  boardingSoon,
  awaitingBoarding,
  boarded,
  missed,
  cancelled,
  completed;

  static ReservationStatus fromString(String? value) {
    return ReservationStatus.values.firstWhere(
          (e) => _firestoreName(e) == value,
      orElse: () => ReservationStatus.reserved,
    );
  }

  static String _firestoreName(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.boardingSoon:
        return 'boarding_soon';
      case ReservationStatus.awaitingBoarding:
        return 'awaiting_boarding';
      default:
        return status.name;
    }
  }

  String get firestoreValue => _firestoreName(this);
}