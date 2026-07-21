import 'package:flutter/material.dart';

import '../../data/models/driver_status.dart';

class DashboardHeader extends StatelessWidget {
  final String driverName;
  final DriverStatus status;

  const DashboardHeader({
    super.key,
    required this.driverName,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case DriverStatus.ready:
        return "Ready for Duty";

      case DriverStatus.online:
        return "Online";

      case DriverStatus.onTrip:
        return "On Trip";

      case DriverStatus.paused:
        return "Trip Paused";

      case DriverStatus.offline:
        return "Offline";
    }
  }

  Color get statusColor {
    switch (status) {
      case DriverStatus.ready:
        return Colors.orange;

      case DriverStatus.online:
        return Colors.green;

      case DriverStatus.onTrip:
        return Colors.blue;

      case DriverStatus.paused:
        return Colors.amber;

      case DriverStatus.offline:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    final greeting = hour < 12
        ? "Good Morning"
        : hour < 17
        ? "Good Afternoon"
        : "Good Evening";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          driverName,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 10),

        Chip(
          avatar: CircleAvatar(
            radius: 5,
            backgroundColor: statusColor,
          ),
          label: Text(statusText),
        ),
      ],
    );
  }
}