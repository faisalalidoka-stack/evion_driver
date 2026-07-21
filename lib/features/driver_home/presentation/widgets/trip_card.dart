import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';

import '/features/trip/presentation/cubit/trip_cubit.dart';
import '/features/trip/presentation/cubit/trip_state.dart';

import '../../../driver_home/presentation/cubit/dashboard_cubit.dart';
import '../../../../core/utils/date_time_extensions.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripCubit, TripState>(
      builder: (context, state) {
        final trip = state.trip;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                icon: Icons.alt_route,
                title: "Today's Trip",
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Chip(
                    avatar: Icon(
                      trip.active ? Icons.play_arrow : Icons.stop,
                      size: 18,
                    ),
                    label: Text(trip.status),
                  ),
                  const SizedBox(height: 16),

                  if (trip.startTime != null)
                    Text(
                      "Started: ${trip.startTime!.toTimeString()}",
                    ),

                  if (trip.endTime != null)
                    Text(
                      "Ended: ${trip.endTime!.toTimeString()}",
                    ),

                  const SizedBox(height: 20),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final tripCubit = context.read<TripCubit>();
                    final dashboardCubit = context.read<DashboardCubit>();

                    if (trip.active) {
                      tripCubit.endTrip();
                      dashboardCubit.setReady();
                    } else {
                      tripCubit.startTrip();
                      dashboardCubit.startDriving();
                    }
                  },
                  icon: Icon(
                    trip.active
                        ? Icons.stop_circle
                        : Icons.play_circle_fill,
                  ),
                  label: Text(
                    trip.active
                        ? "End Trip"
                        : "Start Trip",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}