class DriverModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String assignedBus;

  const DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.assignedBus,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'assignedBus': assignedBus,
    };
  }
}