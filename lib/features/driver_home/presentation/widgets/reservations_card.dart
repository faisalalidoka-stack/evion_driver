import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../../../../core/widgets/dashboard_section_title.dart';
import '../../../../core/widgets/dashboard_error_card.dart';

import '../../../reservations/data/models/reservation_model.dart';
import '../../../reservations/presentation/cubit/reservation_cubit.dart';
import '../../../reservations/presentation/cubit/reservation_state.dart';

import '../../../authentication/presentation/cubit/auth_cubit.dart';

class ReservationsCard extends StatelessWidget {
  const ReservationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        if (state.loading) {
          if (state.error != null) {
            return DashboardErrorCard(
              message: state.error!,
              onRetry: () {
                final driverId = context.read<AuthCubit>().state.driver!.id;
                context.read<ReservationCubit>().listenReservations(driverId);
              },
            );
          }
          return const DashboardCard(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final active = state.reservations.where((r) => !r.isCancelled).toList();

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
                "${active.length} Reservation(s)",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 16),

              ...state.reservations.take(3).map(
                    (reservation) => _ReservationTile(reservation: reservation),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReservationTile extends StatelessWidget {
  final ReservationModel reservation;

  const _ReservationTile({required this.reservation});

  Color _statusColor() {
    if (reservation.isBoarded || reservation.isCompleted) return Colors.green;
    if (reservation.isAwaitingBoarding) return Colors.blue;
    if (reservation.isBoardingSoon) return Colors.orange;
    if (reservation.isMissed || reservation.isCancelled) return Colors.red;
    return Colors.grey;
  }

  String _statusLabel() {
    if (reservation.isBoarded) return "Boarded";
    if (reservation.isCompleted) return "Completed";
    if (reservation.isAwaitingBoarding) return "Awaiting Boarding";
    if (reservation.isBoardingSoon) return "Boarding Soon";
    if (reservation.isMissed) return "Missed";
    if (reservation.isCancelled) return "Cancelled";
    return "Reserved";
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return Opacity(
      opacity: (reservation.isCancelled || reservation.isMissed) ? 0.4 : 1,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(reservation.passengerName),
        subtitle: Text(
          "${reservation.pickupStopName} → ${reservation.destinationStopName} • "
              "${reservation.seats} Seat(s)",
        ),
        trailing: reservation.isAwaitingBoarding
            ? ActionChip(
          onPressed: () =>
              context.read<ReservationCubit>().confirmBoarding(reservation),
          avatar: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text("Board Passenger"),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(color: color.withOpacity(0.3)),
        )
            : Chip(
          label: Text(_statusLabel(), style: TextStyle(color: color)),
          backgroundColor: color.withOpacity(0.08),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
    );
  }
}