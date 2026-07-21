class ActiveTrip {
  final bool active;
  final String status;

  final DateTime? startTime;
  final DateTime? endTime;

  const ActiveTrip({
    required this.active,
    required this.status,
    this.startTime,
    this.endTime,
  });

  factory ActiveTrip.initial() {
    return const ActiveTrip(
      active: false,
      status: "Not Started",
    );
  }

  ActiveTrip copyWith({
    bool? active,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return ActiveTrip(
      active: active ?? this.active,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}