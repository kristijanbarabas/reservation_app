import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import 'package:reservation_app/screens/loading_screen.dart';
import 'package:reservation_app/screens/reservation_details_screen.dart';
import 'package:reservation_app/screens/sign_in_screen.dart';
import 'package:reservation_app/screens/registration_screen.dart';
import '../screens/error_screen.dart';
import '../screens/home_screen.dart';

enum AppRoutes { welcome, login, register, home, error, loading, details }

final goRouter = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        name: AppRoutes.home.name,
        //builder: (context, state) => const WelcomeScreen(),
        pageBuilder: ((context, state) =>
            MaterialPage(key: state.pageKey, child: const HomeScreen())),
        routes: [
          GoRoute(
            path: 'login_screen',
            name: AppRoutes.login.name,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'registration_screen',
            name: AppRoutes.register.name,
            builder: (context, state) => const RegistrationScreen(),
          ),
          GoRoute(
            path: 'loading_screen',
            name: AppRoutes.loading.name,
            builder: (context, state) => const LoadingScreen(),
          ),
          GoRoute(
            path:
                'reservation_details_screen/:reservationDate/:reservationTime',
            name: AppRoutes.details.name,
            builder: (context, state) {
              final reservationDate = state.params['reservationDate']!;
              final reservationTime = state.params['reservationTime']!;
              return ReservationDetailsScreen(
                  reservationDate: reservationDate,
                  reservationTime: reservationTime);
            },
          )
        ]),
  ],
);

final goRouterError = GoRouter(routes: [
  GoRoute(
      path: '/',
      name: AppRoutes.error.name,
      builder: (context, state) => const ErrorScreen())
]);
