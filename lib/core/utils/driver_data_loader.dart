import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/driver_home/presentation/cubit/dashboard_cubit.dart';
import '../../features/bus/presentation/cubit/bus_cubit.dart';
import '/features/route/data/cubit/route_cubit.dart';
import '../../features/reservations/presentation/cubit/reservation_cubit.dart';

/// Loads all driver-scoped data (dashboard, bus, route, reservations)
/// for the given [driverId]. Must be called once a driver is authenticated,
/// from both the login flow and the splash "already signed in" flow.
void loadDriverData(BuildContext context, String driverId) {
  context.read<DashboardCubit>().loadDashboard(driverId);
  context.read<BusCubit>().loadBus(driverId);
  context.read<RouteCubit>().loadRoute(driverId);
  context.read<ReservationCubit>().listenReservations(driverId);
}