import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';

import 'features/driver_home/data/repositories/dashboard_repository.dart';
import 'features/driver_home/presentation/cubit/dashboard_cubit.dart';

import 'features/trip/data/repositories/trip_repository.dart';
import 'features/trip/presentation/cubit/trip_cubit.dart';

import 'features/bus/data/repositories/bus_repository.dart';
import 'features/bus/presentation/cubit/bus_cubit.dart';

import 'features/route/data/repositories/route_repository.dart';
import '/features/route/data/cubit/route_cubit.dart';

import 'features/reservations/data/repositories/reservation_repository.dart';
import 'features/reservations/presentation/cubit/reservation_cubit.dart';

import 'core/services/location_service.dart';

class EvionDriverApp extends StatelessWidget {
  const EvionDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            AuthRepository(),
          ),
        ),

        BlocProvider<DashboardCubit>(
          create: (_) => DashboardCubit(
            DashboardRepository(),
          ),
        ),

        BlocProvider<TripCubit>(
          create: (_) => TripCubit(
            TripRepository(),
            LocationService(),
          ),
        ),
        BlocProvider<BusCubit>(
          create: (_) => BusCubit(
            BusRepository(),
          ),
        ),
        BlocProvider<RouteCubit>(
          create: (_) => RouteCubit(
            RouteRepository(),
          ),
        ),
        BlocProvider<ReservationCubit>(
          create: (_) => ReservationCubit(
            ReservationRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'EViON Driver',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}