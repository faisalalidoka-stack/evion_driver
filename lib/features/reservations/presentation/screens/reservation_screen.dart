import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/entities/trip.dart';
import '../../../home/domain/entities/bus_stop.dart';
import '../../../tracking/presentation/screens/active_trip_screen.dart';
import '../../controllers/reservation_controller.dart';
import '../../domain/reservation_state.dart';

class ReservationScreen extends ConsumerWidget {
  final Trip trip;
  final BusStop destination;

  const ReservationScreen({super.key, required this.trip, required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ReservationState>(reservationControllerProvider, (previous, next) {
      if (next.status == ReservationFlowStatus.confirmed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ActiveTripScreen(destination: destination, tripId: trip.id),
          ),
        );
      }

      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    final isSubmitting = ref.watch(reservationControllerProvider.select((s) => s.isSubmitting));

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Reservation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.directions_bus)),
                title: Text("Bus ${trip.busId}"),
                subtitle: const Text("Assigned Bus"),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(destination.name),
                subtitle: const Text("Destination"),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_seat),
                title: const Text("Seats Available"),
                trailing: Text(trip.availableSeats.toString()),
              ),
            ),
            const Spacer(),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 55)),
              onPressed: isSubmitting
                  ? null
                  : () => ref.read(reservationControllerProvider.notifier).confirmReservation(),
              child: isSubmitting
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text("Reserve Seat"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}