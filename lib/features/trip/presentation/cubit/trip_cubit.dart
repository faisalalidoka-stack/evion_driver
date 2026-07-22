import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/location_service.dart';
import '../../data/models/trip_status.dart';
import '../../data/repositories/trip_repository.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit(this._repository, this._locationService)
      : super(TripState.initial());

  final TripRepository _repository;
  final LocationService _locationService;

  StreamSubscription? _tripSubscription;
  StreamSubscription<Position>? _locationSubscription;

  void watchTrip(String driverId) {
    emit(state.copyWith(loading: true, clearError: true));

    _tripSubscription?.cancel();
    _tripSubscription = _repository.watchActiveTrip(driverId).listen(
          (trip) {
        emit(TripState(trip: trip, loading: false));

        if (trip != null && trip.status == TripStatus.active) {
          _startLocationUpdates(trip.id);
        } else {
          _stopLocationUpdates();
        }
      },
      onError: (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      },
    );
  }

  Future<void> _startLocationUpdates(String tripId) async {
    if (_locationSubscription != null) return;

    final granted = await _locationService.ensurePermission();
    if (!granted) return;

    _locationSubscription = _locationService.positionStream().listen(
          (position) {
        _repository.updateLocation(
          tripId,
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed,
          heading: position.heading,
        );
      },
      onError: (_) {
        // Location stream errors don't need to surface to the driver —
        // GPS will just resume once the OS/device fixes itself.
      },
    );
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<bool> startTrip({
    required String driverId,
    required String busId,
    required String routeId,
    required int availableSeats,
  }) async {
    try {
      await _repository.startTrip(
        driverId: driverId,
        busId: busId,
        routeId: routeId,
        availableSeats: availableSeats,
      );
      return true;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  Future<bool> endTrip() async {
    final trip = state.trip;
    if (trip == null) return false;

    try {
      await _repository.endTrip(trip.id);
      return true;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  @override
  Future<void> close() {
    _tripSubscription?.cancel();
    _stopLocationUpdates();
    return super.close();
  }
}