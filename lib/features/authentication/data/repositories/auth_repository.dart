import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({
    AuthService? authService,
    FirebaseFirestore? firestore,
  })  : _authService = authService ?? AuthService(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final AuthService _authService;
  final FirebaseFirestore _firestore;

  Future<DriverModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc =
    await _firestore.collection('drivers').doc(uid).get();

    if (!doc.exists) {
      throw Exception("Driver profile not found.");
    }

    return DriverModel.fromMap(
      uid,
      doc.data()!,
    );
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}