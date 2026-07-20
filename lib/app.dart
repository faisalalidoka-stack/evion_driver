import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';

class EvionDriverApp extends StatelessWidget {
  const EvionDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        AuthRepository(),
      ),
      child: MaterialApp.router(
        title: 'EViON Driver',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}