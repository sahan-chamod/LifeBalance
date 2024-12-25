import 'package:flutter/material.dart';
import 'package:life_balance/screens/profile/AddMediAlegic.dart';
import 'package:life_balance/screens/profile/CustomerHistoryScreen.dart';
import 'package:life_balance/screens/profile/FoodAllergyScreen.dart';
import 'package:life_balance/screens/profile/MediAlegicScreen.dart';
import 'package:life_balance/screens/profile/PasswordScreen.dart';
import 'package:life_balance/screens/profile/PrivacyPolicyScreen.dart';
import 'package:life_balance/screens/profile/UserProfileScreen.dart';
import 'package:life_balance/screens/profile/addFoodAllergiesScreen.dart';
import '../screens/Loginscreen.dart';
import '../screens/Signupscreen.dart';
import '../screens/Patients/HomeScreen.dart';
import '../screens/admin/AdminHome.dart';
import '../screens/doctors/DoctorsHome.dart';
import '../screens/profile/ProfileScreen.dart';
import '../screens/profile/UserProfileScreen.dart';
import '../screens/profile/SettingsScreen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String doctorHome = '/doctor_home';
  static const String adminHome = '/admin_home';
  static const String profile= "/profile";
  static const String userProfile="/userProfile";
  static const String userSettings="/settings";
  static const String password="/password";
  static const String privacyPolicy="/privacy";
  static const String customerHistory="/history";
  static const String mediAlegic="/mediAlegic";
  static const String addMediAlegic="/addMedAligic";
  static const String foodAllergy="/foodAllergy";
  static const String addFoodAllergy="/addFoodAllergy";



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
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());
      case userSettings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case password:
        return MaterialPageRoute(builder: (_) => const PasswordScreen());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case customerHistory:
        return MaterialPageRoute(builder: (_) => const CustomerHistoryScreen());
      case mediAlegic:
        return MaterialPageRoute(builder: (_) => const MediAlegicScreen());
      case addMediAlegic:
        return MaterialPageRoute(builder: (_) => const AddMediAlegic());
      case foodAllergy:
        return MaterialPageRoute(builder: (_) => const FoodAllergyScreen());
      case addFoodAllergy:
        return MaterialPageRoute(builder: (_) => const AddFoodAllergiesScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
