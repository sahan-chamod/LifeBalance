import 'package:flutter/material.dart';
import '../screens/Loginscreen.dart';
import '../screens/Signupscreen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUp());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
