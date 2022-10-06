import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/components/booking_calendar.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:reservation_app/screens/login_screen.dart';
import 'package:reservation_app/screens/registration_screen.dart';
import 'package:reservation_app/screens/test.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting()
      .then((_) => runApp(const ProviderScope(child: ReservationApp())));
}

class ReservationApp extends StatelessWidget {
  const ReservationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        CustomBookingCalendar.id: (context) => const CustomBookingCalendar(),
        Test.id: (context) => const Test(),
      },
    );
  }
}
