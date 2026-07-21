class DriverModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String assignedBus;
  final bool online;

  const DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.assignedBus,
    required this.online,
  });

  factory DriverModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return DriverModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      assignedBus: map['assignedBus'] ?? '',
      online: map['online'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'assignedBus': assignedBus,
      'online': online,
    };
  }
}