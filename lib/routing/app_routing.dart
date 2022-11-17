import 'package:flutter/cupertino.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import '../screens/booking_calendar.dart';
import '../screens/home.dart';
import '../screens/sign_in_screen.dart';
import '../screens/registration_screen.dart';

//TODO delete this file after migration to GoRouter
Map<String, WidgetBuilder> appRoutes = {
  WelcomeScreen.id: (context) => const WelcomeScreen(),
  RegistrationScreen.id: (context) => const RegistrationScreen(),
  LoginScreen.id: (context) => const LoginScreen(),
  HomeScreen.id: (context) => const HomeScreen(),
  CustomBookingCalendar.id: (context) => const CustomBookingCalendar(),
};
