import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver_model.dart';
import '../services/auth_service.dart';
import '../services/driver_service.dart';

class AuthRepository {
  AuthRepository({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final DriverService _driverService = DriverService();
  final AuthService _authService;

  User? get currentUser => _authService.currentUser;

  Future<DriverModel> fetchDriver(String uid) {
    return _driverService.getDriver(uid);
  }

  Future<DriverModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(
      email: email,
      password: password,
    );

    return fetchDriver(credential.user!.uid);
  }

  Future<void> logout() {
    return _authService.signOut();
  }
}
