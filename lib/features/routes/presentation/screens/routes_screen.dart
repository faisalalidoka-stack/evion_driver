import 'package:flutter/material.dart';

import '../../../../shared/data/dummy_routes.dart';
import '../../../home/domain/entities/bus_stop.dart';
import '../../../reservations/presentation/screens/bus_selection_screen.dart';

class RoutesScreen extends StatelessWidget {
  final BusStop destination;

  const RoutesScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final route = dummyRoutes.first;

    return Scaffold(
      appBar: AppBar(title: const Text("Journey")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recommended Route",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(route.name),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BusSelectionScreen(destination: destination),
                    ),
                  );
                },
                child: const Text("Choose a Bus"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}