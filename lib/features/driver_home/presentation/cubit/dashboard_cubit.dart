import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

import '../../data/models/driver_status.dart';

import '../../../authentication/data/models/driver_model.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
      this._repository,
      ) : super(DashboardState.initial());

  final DashboardRepository _repository;

  Future<void> loadDashboard(String driverId) async {
    emit(
      state.copyWith(
        loading: true,
      ),
    );

    final dashboard =
    await _repository.getDashboard(driverId);

    emit(
      state.copyWith(
        data: dashboard,
        loading: false,
      ),
    );
  }

  void toggleOnline(bool value) {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          online: value,
        ),
      ),
    );
  }
  Future<void> goOnline(String driverId) async {
    await _repository.updateOnlineStatus(
      driverId: driverId,
      online: true,
    );

    emit(
      state.copyWith(
        data: state.data.copyWith(
          online: true,
          driverStatus: DriverStatus.online,
        ),
      ),
    );
  }

  Future<void> goOffline(String driverId) async {
    await _repository.updateOnlineStatus(
      driverId: driverId,
      online: false,
    );

    emit(
      state.copyWith(
        data: state.data.copyWith(
          online: false,
          driverStatus: DriverStatus.offline,
        ),
      ),
    );
  }

  void setReady() {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          online: false,
          driverStatus: DriverStatus.ready,
        ),
      ),
    );
  }

  void pauseTrip() {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          driverStatus: DriverStatus.paused,
        ),
      ),
    );
  }

  void startDriving() {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          driverStatus: DriverStatus.onTrip,
        ),
      ),
    );
  }
  void updateDriver(DriverModel driver) {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          driverName: driver.name,
          online: driver.online,
        ),
      ),
    );
  }

}