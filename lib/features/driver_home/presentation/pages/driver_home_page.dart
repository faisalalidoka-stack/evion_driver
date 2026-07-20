import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../trip/data/models/route_model.dart';
import '../../../trip/data/repositories/reference_data_repository.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';
import '../../../trip/presentation/cubit/trip_state.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final _referenceDataRepository = ReferenceDataRepository();

  List<RouteModel> _routes = [];
  RouteModel? _selectedRoute;
  bool _loadingRoutes = true;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    final routes = await _referenceDataRepository.fetchRoutes();

    if (!mounted) return;

    setState(() {
      _routes = routes;
      _selectedRoute = routes.isNotEmpty ? routes.first : null;
      _loadingRoutes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final driver = context.watch<AuthCubit>().state.driver;

    return BlocProvider(
      create: (_) =>
          TripCubit(referenceDataRepository: _referenceDataRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Driver Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${driver?.name ?? 'Driver'}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Assigned bus: ${driver?.assignedBus ?? '—'}"),
              const SizedBox(height: 24),

              BlocBuilder<TripCubit, TripState>(
                builder: (context, state) {
                  final onTrip = state.status == DriverTripStatus.onTrip;
                  if (onTrip) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select a route",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _loadingRoutes
                          ? const Center(child: CircularProgressIndicator())
                          : _routes.isEmpty
                          ? const Text(
                        "No routes found. Add some in Firestore first.",
                        style: TextStyle(color: Colors.red),
                      )
                          : DropdownButtonFormField<RouteModel>(
                        value: _selectedRoute,
                        isExpanded: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder()),
                        items: _routes
                            .map((route) => DropdownMenuItem(
                          value: route,
                          child: Text(route.name),
                        ))
                            .toList(),
                        onChanged: (route) =>
                            setState(() => _selectedRoute = route),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

              BlocConsumer<TripCubit, TripState>(
                listener: (context, state) {
                  if (state.status == DriverTripStatus.error &&
                      state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message!)),
                    );
                  }
                },
                builder: (context, state) {
                  final onTrip = state.status == DriverTripStatus.onTrip;
                  final busy = state.status == DriverTripStatus.starting ||
                      state.status == DriverTripStatus.ending;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: ListTile(
                          leading: Icon(
                            onTrip ? Icons.directions_bus : Icons.pause_circle_outline,
                            color: onTrip ? Colors.green : Colors.grey,
                          ),
                          title: Text(onTrip ? "Trip in progress" : "No active trip"),
                          subtitle: state.trip != null
                              ? Text("Route: ${state.trip!.routeId}")
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            backgroundColor: onTrip ? Colors.red : null,
                          ),
                          onPressed: busy ||
                              driver == null ||
                              (!onTrip && _selectedRoute == null)
                              ? null
                              : () {
                            if (onTrip) {
                              context.read<TripCubit>().endTrip();
                            } else {
                              context.read<TripCubit>().startTrip(
                                driverId: driver.id,
                                assignedBus: driver.assignedBus,
                                route: _selectedRoute!,
                              );
                            }
                          },
                          child: busy
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(onTrip ? "End Trip" : "Start Trip"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}