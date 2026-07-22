import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';

import '../../../bus/presentation/cubit/bus_cubit.dart';
import '../../../bus/presentation/cubit/bus_state.dart';

import '../../../reservations/presentation/cubit/reservation_cubit.dart';
import '../../../reservations/presentation/cubit/reservation_state.dart';

import '../../../../core/widgets/dashboard_error_card.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';

class BusCard extends StatelessWidget {
  const BusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, busState) {
        if (busState.loading) {
          if (busState.error != null) {
            return DashboardErrorCard(
              message: busState.error!,
              onRetry: () {
                final driverId = context.read<AuthCubit>().state.driver!.id;
                context.read<BusCubit>().loadBus(driverId);
              },
            );
          }
          return const DashboardCard(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final bus = busState.bus;

        return BlocBuilder<ReservationCubit, ReservationState>(
          builder: (context, reservationState) {
            final reservedSeats = reservationState.reservations
                .where((r) => !r.isCancelled)
                .fold<int>(0, (sum, r) => sum + r.seats);

            final liveAvailable =
            (bus.totalSeats - reservedSeats).clamp(0, bus.totalSeats);

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
                      Text("$liveAvailable/${bus.totalSeats} Seats"),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}