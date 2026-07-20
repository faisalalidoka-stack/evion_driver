import '../../data/models/driver_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final DriverModel? driver;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.driver,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    DriverModel? driver,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      driver: driver ?? this.driver,
      message: message ?? this.message,
    );
  }
}