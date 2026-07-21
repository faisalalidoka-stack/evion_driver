import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dashboard_card.dart';
import '../cubit/dashboard_cubit.dart';

import '../../../authentication/presentation/cubit/auth_cubit.dart';

class OnlineToggle extends StatelessWidget {
  final bool online;

  const OnlineToggle({
    super.key,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: online ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              online ? "ONLINE" : "OFFLINE",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Switch(
            value: online,
            onChanged: (value) {
              final driver =
              context.read<AuthCubit>().state.driver!;

              if (value) {
                context.read<DashboardCubit>().goOnline(driver.id);;
              } else {
                context.read<DashboardCubit>().goOffline(driver.id);;
              }
            },
          ),
        ],
      ),
    );
  }
}