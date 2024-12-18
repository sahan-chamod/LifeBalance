import 'package:flutter/material.dart';
import '../screens/Loginscreen.dart';
import '../screens/Patients/payment/AddCardScreen.dart';
import '../screens/Patients/payment/PaymentMethodApp.dart';
import '../screens/Signupscreen.dart';
import '../screens/Patients/HomeScreen.dart';
import '../screens/admin/AdminHome.dart';
import '../screens/doctors/DoctorsHome.dart';
import '../screens/Patients/Chat/ChatScreen.dart';
import '../screens/Patients/Notifications/NotificationsScreen.dart';
import '../screens/Patients/Schedule/ScheduleScreen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String doctorHome = '/doctor_home';
  static const String adminHome = '/admin_home';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String schedule = '/schedule';
  static const String Payments = '/payments';
  static const String addcards = '/addcards';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const Chat());
      case notifications:
        return MaterialPageRoute(builder: (_) => const Notifications());
      case schedule:
        return MaterialPageRoute(builder: (_) => const Schedule());
      case Payments:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());
      case adminHome:
        return MaterialPageRoute(builder: (_) => AddCardScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
