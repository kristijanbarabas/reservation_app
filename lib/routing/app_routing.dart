import 'package:flutter/cupertino.dart';
import '../screens/booking_calendar.dart';
import '../screens/loading_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/registration_screen.dart';

//TODO delete this file after migration to GoRouter
Map<String, WidgetBuilder> appRoutes = {
  RegistrationScreen.id: (context) => const RegistrationScreen(),
  LoginScreen.id: (context) => const LoginScreen(),
  LoadingScreen.id: (context) => const LoadingScreen(),
  CustomBookingCalendar.id: (context) => const CustomBookingCalendar(),
};
