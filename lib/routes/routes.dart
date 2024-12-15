import 'package:flutter/material.dart';
import '../screens/Loginscreen.dart';
import '../screens/Signupscreen.dart';
import '../screens/Patients/HomeScreen.dart';
import '../screens/admin/AdminHome.dart';
import '../screens/doctors/DoctorsHome.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String doctorHome = '/doctor_home';
  static const String adminHome = '/admin_home';

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
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
