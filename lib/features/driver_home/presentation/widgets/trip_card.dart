import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';
import '../../../../core/widgets/dashboard_error_card.dart';
import '../../../../core/utils/date_time_extensions.dart';

import '../../../trip/presentation/cubit/trip_cubit.dart';
import '../../../trip/presentation/cubit/trip_state.dart';
import '../../../trip/data/models/trip_status.dart';

import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../bus/presentation/cubit/bus_cubit.dart';
import '/features/route/data/cubit/route_cubit.dart';

import '../../../reservations/presentation/cubit/reservation_cubit.dart';

import '../cubit/dashboard_cubit.dart';

import 'package:go_router/go_router.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripCubit, TripState>(
      builder: (context, state) {
        if (state.error != null && state.trip == null) {
          return DashboardErrorCard(
            message: state.error!,
            onRetry: () {
              final driverId = context.read<AuthCubit>().state.driver!.id;
              context.read<TripCubit>().watchTrip(driverId);
            },
          );
        }

        final trip = state.trip;
        final active = trip != null &&
            trip.status != TripStatus.completed &&
            trip.status != TripStatus.cancelled;

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
                      active ? Icons.play_arrow : Icons.stop,
                      size: 18,
                    ),
                    label: Text(trip == null ? "Not Started" : trip.status.name),
                  ),
                ],
              ),

              if (trip != null) ...[
                const SizedBox(height: 12),
                Text("Started: ${trip.startedAt.toTimeString()}"),
                if (trip.completedAt != null)
                  Text("Ended: ${trip.completedAt!.toTimeString()}"),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.loading
                      ? null
                      : () async {
                    final tripCubit = context.read<TripCubit>();
                    final dashboardCubit = context.read<DashboardCubit>();
                    final driverId =
                        context.read<AuthCubit>().state.driver!.id;

                    bool ok;
                    if (active) {
                      ok = await tripCubit.endTrip();
                      if (ok) {
                        dashboardCubit.setReady();
                        context.read<BusCubit>().resetSeats();
                        context
                            .read<ReservationCubit>()
                            .completeBoardedReservations();
                      }
                    } else {
                      final bus = context.read<BusCubit>().state.bus;
                      final route =
                          context.read<RouteCubit>().state.route;

                      ok = await tripCubit.startTrip(
                        driverId: driverId,
                        busId: bus.id,
                        routeId: route.id,
                        availableSeats: bus.availableSeats,
                      );
                      if (ok) dashboardCubit.startDriving();
                    }

                    if (!ok && context.mounted) {
                      final message = tripCubit.state.error ??
                          "Something went wrong. Please try again.";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  },
                  icon: Icon(
                    active ? Icons.stop_circle : Icons.play_circle_fill,
                  ),
                  label: Text(active ? "End Trip" : "Start Trip"),
                ),
              ),
              if (active) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/trip-stops'),
                    icon: const Icon(Icons.route_outlined),
                    label: const Text("View Stops"),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}