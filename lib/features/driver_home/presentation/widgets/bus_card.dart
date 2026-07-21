import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';

import '../../../bus/presentation/cubit/bus_cubit.dart';
import '../../../bus/presentation/cubit/bus_state.dart';

class BusCard extends StatelessWidget {
  const BusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, state) {
        if (state.loading) {
          return const DashboardCard(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final bus = state.bus;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                icon: Icons.directions_bus,
                title: "Assigned Bus",
              ),

              const SizedBox(height: 20),

              Text(
                bus.code,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.badge_outlined),
                  const SizedBox(width: 8),
                  Text(bus.registration),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.event_seat_outlined),
                  const SizedBox(width: 8),
                  Text(
                    "${bus.availableSeats}/${bus.totalSeats} Seats",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}