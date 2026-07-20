import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final driver = await _repository.login(
        email: email,
        password: password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          driver: driver,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();

    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
      ),
    );
  }
}