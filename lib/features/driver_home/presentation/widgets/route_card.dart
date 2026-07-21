import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';

import '/features/route/data/cubit/route_cubit.dart';
import '/features/route/data/route_state.dart';


class RouteCard extends StatelessWidget {
  const RouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, state) {
        if (state.loading) {
          return const DashboardCard(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final route = state.route;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                icon: Icons.route,
                title: "Assigned Route",
              ),

              const SizedBox(height: 20),

              Text(
                route.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.trip_origin),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(route.start),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.flag),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(route.destination),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Text("${route.stopCount} Stops"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}