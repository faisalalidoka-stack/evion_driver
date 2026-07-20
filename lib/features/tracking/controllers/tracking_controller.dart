import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../shared/domain/entities/trip.dart';
import '../../../shared/domain/repositories/trip_repository.dart';
import '../../../shared/providers/repository_providers.dart';
import '../domain/tracking_state.dart';

/// Purely reads the live trip document — the driver app is the real
/// source of truth for position now, so this no longer simulates
/// anything.
class TrackingController extends StateNotifier<TrackingState> {
  TrackingController(this._tripRepository) : super(const TrackingState());

  final TripRepository _tripRepository;
  StreamSubscription<Trip>? _tripSub;

  void start(String tripId) {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);

    _tripSub = _tripRepository.watchTrip(tripId).listen((trip) {
      state = state.copyWith(trip: trip);
    });
  }

  void stop() {
    _tripSub?.cancel();
    if (mounted) {
      state = state.copyWith(isRunning: false);
    }
  }

  @override
  void dispose() {
    _tripSub?.cancel();
    super.dispose();
  }
}

final trackingControllerProvider =
StateNotifierProvider<TrackingController, TrackingState>((ref) {
  return TrackingController(ref.watch(tripRepositoryProvider));
});