import 'package:flutter/material.dart';

class _TripView extends StatelessWidget {
  final ReservationState reservation;

  const _TripView({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final trip = reservation.selectedTrip!;
    final destination = reservation.destination!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bus ${trip.busId}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(destination.name),
            subtitle: const Text("Destination"),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event_seat),
            title: const Text("Available Seats"),
            trailing: Text("${trip.availableSeats}"),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: const Icon(Icons.map),
            label: const Text("Open Live Trip"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActiveTripScreen(
                    destination: destination,
                    tripId: trip.id,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}