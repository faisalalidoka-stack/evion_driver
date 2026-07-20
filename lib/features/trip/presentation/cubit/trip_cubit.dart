import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/location_service.dart';
import '../../data/models/route_model.dart';
import '../../data/models/trip_model.dart';
import '../../data/models/trip_status.dart';
import '../../data/repositories/reference_data_repository.dart';
import '../../data/repositories/trip_repository.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit({
    TripRepository? tripRepository,
    LocationService? locationService,
    ReferenceDataRepository? referenceDataRepository,
  })  : _tripRepository = tripRepository ?? TripRepository(),
        _locationService = locationService ?? LocationService(),
        _referenceDataRepository =
            referenceDataRepository ?? ReferenceDataRepository(),
        super(const TripState());

  final TripRepository _tripRepository;
  final LocationService _locationService;
  final ReferenceDataRepository _referenceDataRepository;

  StreamSubscription<Position>? _positionSub;

  Future<void> startTrip({
    required String driverId,
    required String assignedBus,
    required RouteModel route,
  }) async {
    emit(state.copyWith(status: DriverTripStatus.starting));

    final hasPermission = await _locationService.ensurePermission();

    if (!hasPermission) {
      emit(state.copyWith(
        status: DriverTripStatus.error,
        message: 'Location permission is required to start a trip.',
      ));
      return;
    }

    try {
      final bus = await _referenceDataRepository.fetchBus(assignedBus);
      final tripId = _tripRepository.generateTripId();

      final trip = TripModel(
        id: tripId,
        routeId: route.id,
        driverId: driverId,
        busId: assignedBus,
        currentLocation: route.polyline.isNotEmpty
            ? route.polyline.first
            : const GeoPoint(0.3334, 32.5686),
        availableSeats: bus?.capacity ?? 30,
        speed: 0,
        heading: 0,
        status: TripStatus.boarding,
        startedAt: DateTime.now(),
      );

      await _tripRepository.startTrip(trip);
      emit(state.copyWith(status: DriverTripStatus.onTrip, trip: trip));

      _positionSub = _locationService.positionStream().listen((position) {
        _tripRepository.updateLocation(
          tripId,
          location: GeoPoint(position.latitude, position.longitude),
          speed: position.speed,
          heading: position.heading,
        );
      });
    } catch (e) {
      emit(state.copyWith(
        status: DriverTripStatus.error,
        message: 'Could not start the trip. Please try again.',
      ));
    }
  }

  Future<void> endTrip() async {
    final trip = state.trip;
    if (trip == null) return;

    emit(state.copyWith(status: DriverTripStatus.ending));

    await _positionSub?.cancel();
    await _tripRepository.endTrip(trip.id);

    emit(const TripState());
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    return super.close();
  }
}