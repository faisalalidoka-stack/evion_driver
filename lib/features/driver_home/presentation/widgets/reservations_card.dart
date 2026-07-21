import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';

import '../../../reservations/presentation/cubit/reservation_cubit.dart';
import '../../../reservations/presentation/cubit/reservation_state.dart';

class ReservationsCard extends StatelessWidget {
  const ReservationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        if (state.loading) {
          return const DashboardCard(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardSectionTitle(
                icon: Icons.confirmation_number_outlined,
                title: "Today's Reservations",
              ),

              const SizedBox(height: 20),

              Text(
                "${state.reservations.length} Reservation(s)",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 16),

              ...state.reservations.take(3).map(
                    (reservation) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(reservation.passengerName),
                  subtitle: Text(
                    "${reservation.pickupStop} → ${reservation.destinationStop}",
                  ),
                  trailing: Text(
                    "${reservation.seats} Seat(s)",
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