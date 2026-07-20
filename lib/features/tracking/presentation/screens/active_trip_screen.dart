import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/bus_stop.dart';
import '../../controllers/tracking_controller.dart';

class ActiveTripScreen extends ConsumerStatefulWidget {
  final BusStop destination;
  final String tripId;

  const ActiveTripScreen({super.key, required this.destination, required this.tripId});

  @override
  ConsumerState<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends ConsumerState<ActiveTripScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trackingControllerProvider.notifier).start(widget.tripId);
    });
  }

  @override
  void dispose() {
    ref.read(trackingControllerProvider.notifier).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(trackingControllerProvider);
    final trip = tracking.trip;

    return Scaffold(
      appBar: AppBar(title: const Text("Active Trip"), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.directions_bus)),
                title: Text(trip != null ? "Bus ${trip.busId}" : "Bus"),
                subtitle: const Text("Assigned Bus"),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(widget.destination.name),
                subtitle: const Text("Destination"),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.speed),
                title: const Text("Current Speed"),
                trailing: Text("${(trip?.speed ?? 0).toStringAsFixed(0)} km/h"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_seat),
                title: const Text("Seats Available"),
                trailing: Text("${trip?.availableSeats ?? '-'}"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text("Status"),
                trailing: Chip(label: Text((trip?.status.name ?? 'waiting').toUpperCase())),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 55)),
              icon: const Icon(Icons.map),
              label: const Text("View Bus On Map"),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }
}