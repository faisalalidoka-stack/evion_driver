import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/repository_providers.dart';
import '../../../home/domain/entities/bus_stop.dart';
import '../../controllers/reservation_controller.dart';
import 'reservation_screen.dart';

class BusSelectionScreen extends ConsumerWidget {
  final BusStop destination;

  const BusSelectionScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTrips = ref.watch(activeTripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Available Buses")),
      body: activeTrips.when(
        data: (trips) {
          if (trips.isEmpty) {
            return const Center(
              child: Text("No buses are currently running. Check back soon."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              final isFull = trip.availableSeats <= 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.directions_bus)),
                  title: Text("Bus ${trip.busId}"),
                  subtitle: Text(isFull ? "Full" : "${trip.availableSeats} seats available"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: isFull
                      ? null
                      : () {
                    ref.read(reservationControllerProvider.notifier).selectJourney(
                      trip: trip,
                      destination: destination,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReservationScreen(
                          trip: trip,
                          destination: destination,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Couldn't load buses: $e")),
      ),
    );
  }
}