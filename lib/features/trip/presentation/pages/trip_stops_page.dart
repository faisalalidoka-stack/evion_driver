import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_error_card.dart';
import '../../../route/data/cubit/route_cubit.dart';
import '../cubit/trip_cubit.dart';
import '../cubit/trip_state.dart';
import '../cubit/trip_stops_cubit.dart';
import '../cubit/trip_stops_state.dart';
import '../../../stops/data/repositories/stop_repository.dart';

class TripStopsPage extends StatelessWidget {
  const TripStopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stopIds = context.read<RouteCubit>().state.route.stopIds;

    return BlocProvider(
      create: (_) => TripStopsCubit(StopRepository())..loadStops(stopIds),
      child: Scaffold(
        appBar: AppBar(title: const Text("Trip Stops")),
        body: const _TripStopsBody(),
      ),
    );
  }
}

class _TripStopsBody extends StatelessWidget {
  const _TripStopsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripStopsCubit, TripStopsState>(
      builder: (context, stopsState) {
        if (stopsState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (stopsState.error != null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: DashboardErrorCard(
              message: stopsState.error!,
              onRetry: () {
                final stopIds = context.read<RouteCubit>().state.route.stopIds;
                context.read<TripStopsCubit>().loadStops(stopIds);
              },
            ),
          );
        }

        return BlocBuilder<TripCubit, TripState>(
          builder: (context, tripState) {
            final trip = tripState.trip;

            if (trip == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "Start a trip to begin stop progression.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final stops = stopsState.stops;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stops.length,
              itemBuilder: (context, index) {
                final stop = stops[index];
                final isPassed = index <= trip.currentStopIndex;
                final isCurrent = index == trip.currentStopIndex;
                final isNext = index == trip.currentStopIndex + 1;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPassed
                        ? Colors.green
                        : isNext
                        ? Colors.orange
                        : Colors.grey.shade300,
                    child: Icon(
                      isPassed ? Icons.check : Icons.location_on_outlined,
                      color: isPassed || isNext ? Colors.white : Colors.black45,
                      size: 18,
                    ),
                  ),
                  title: Text(stop.name),
                  subtitle: Text(
                    isCurrent
                        ? "Current stop"
                        : isPassed
                        ? "Passed"
                        : isNext
                        ? "Next stop"
                        : "Upcoming",
                  ),
                  trailing: isNext
                      ? ElevatedButton(
                    onPressed: () async {
                      final ok = await context
                          .read<TripCubit>()
                          .advanceStop(stop.id, index);

                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Couldn't advance to this stop."),
                          ),
                        );
                      }
                    },
                    child: const Text("Advance"),
                  )
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }
}