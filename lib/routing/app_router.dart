import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:reservation_app/screens/sign_in_screen.dart';
import 'package:reservation_app/screens/registration_screen.dart';
import 'package:reservation_app/screens/welcome_screen.dart';

enum AppRoutes { welcome, login, register, home }

final goRouter = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        name: AppRoutes.welcome.name,
        //builder: (context, state) => const WelcomeScreen(),
        pageBuilder: ((context, state) =>
            MaterialPage(key: state.pageKey, child: const WelcomeScreen())),
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
            path: 'home_screen',
            name: AppRoutes.home.name,
            builder: (context, state) => const HomeScreen(),
          )
        ]),
  ],
);
