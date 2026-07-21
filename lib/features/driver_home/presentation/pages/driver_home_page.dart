import 'package:flutter/material.dart';

import '../widgets/bus_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/online_toggle.dart';
import '../widgets/reservations_card.dart';
import '../widgets/route_card.dart';
import '../widgets/trip_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';



class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = state.data;

              return Column(
                children: [
                  DashboardHeader(
                    driverName: data.driverName,
                    status: data.driverStatus,
                  ),

                  const SizedBox(height: 20),

                  OnlineToggle(
                    online: data.online,
                  ),

                  const SizedBox(height: 16),

                  const BusCard(),

                  const SizedBox(height: 16),

                  const RouteCard(),

                  const SizedBox(height: 16),

                  const TripCard(),

                  const SizedBox(height: 16),

                  const ReservationsCard(),
                ],
              );
            },
          )
        ),
      ),
    );
  }
}