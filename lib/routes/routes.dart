import 'package:flutter/material.dart';
import 'package:life_balance/screens/profile/AddMediAlegic.dart';
import 'package:life_balance/screens/profile/CustomerHistoryScreen.dart';
import 'package:life_balance/screens/profile/FoodAllergyScreen.dart';
import 'package:life_balance/screens/profile/MediAlegicScreen.dart';
import 'package:life_balance/screens/profile/PasswordScreen.dart';
import 'package:life_balance/screens/profile/PrivacyPolicyScreen.dart';
import 'package:life_balance/screens/profile/UserProfileScreen.dart';
import 'package:life_balance/screens/profile/addFoodAllergiesScreen.dart';
import 'package:life_balance/screens/profile/reports/AddReportHistory.dart';
import 'package:life_balance/screens/profile/reports/ReportHistoryScreen.dart';
import '../screens/Loginscreen.dart';
import '../screens/Patients/payment/AddCardScreen.dart';
import '../screens/Patients/payment/PaymentMethodApp.dart';
import '../screens/Signupscreen.dart';
import '../screens/Patients/HomeScreen.dart';
import '../screens/admin/AdminHome.dart';
import '../screens/doctors/DoctorsHome.dart';
import '../screens/profile/ProfileScreen.dart';
import '../screens/profile/UserProfileScreen.dart';
import '../screens/profile/SettingsScreen.dart';
import '../screens/Patients/Chat/ChatScreen.dart';
import '../screens/Patients/Notifications/NotificationsScreen.dart';
import '../screens/Patients/Schedule/ScheduleScreen.dart';
import '../screens/appoinments/appoinment.dart';
import '../screens/Patients/Chat/ChatList.dart';
import '../screens/Doctors Favorite Screens/Doctor Screen 1.dart';
import '../screens/Doctors Favorite Screens/Doctor Screen 2.dart';
import '../screens/Doctors Favorite Screens/Doctor Screen 3.dart';
import '../screens/Doctors Favorite Screens/Doctor Screen 4.dart';
import '../screens/Doctors Favorite Screens/Review screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String doctorHome = '/doctor_home';
  static const String adminHome = '/admin_home';
  static const String profile = "/profile";
  static const String userProfile = "/userProfile";
  static const String userSettings = "/settings";
  static const String password = "/password";
  static const String privacyPolicy = "/privacy";
  static const String customerHistory = "/history";
  static const String mediAlegic = "/mediAlegic";
  static const String addMediAlegic = "/addMedAligic";
  static const String foodAllergy = "/foodAllergy";
  static const String addFoodAllergy = "/addFoodAllergy";
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String schedule = '/schedule';
  static const String Payments = '/payments';
  static const String addcards = '/addcards';
  static const String reportHistory = '/reportHistory';
  static const String addReportHistory = '/addReportHistory';
  static const String chatlist = '/chatlist';

  static const String appoinments = '/appoinments';
  static const String doctorInfo = '/doctorInfo';
  static const String doctorRating = './doctorRating';
  static const String favoriteScreen = './favoriteScreen';
  static const String reviewScreen = './reviewScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorsScreen());
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
        return MaterialPageRoute(
            builder: (_) => const AddFoodAllergiesScreen());
      case chat:
        return MaterialPageRoute(builder: (_) =>  Chat());
      case notifications:
        return MaterialPageRoute(builder: (_) => const Notifications());
      case schedule:
        return MaterialPageRoute(builder: (_) => const Schedule());
      case Payments:
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen());
      case adminHome:
        return MaterialPageRoute(builder: (_) => AddCardScreen());
      case chatlist:
        return MaterialPageRoute(builder: (_) => ChatList());
      case reportHistory:
        return MaterialPageRoute(builder: (_) => const ReportHistoryScreen());
      case addReportHistory:
        return MaterialPageRoute(builder: (_) => AddReportHistory());
      case appoinments:
        return MaterialPageRoute(builder: (_) => Appointments());
      case doctorInfo:
        return MaterialPageRoute(builder: (_) => DoctorInfoScreen());
      case doctorRating:
        return MaterialPageRoute(builder: (_) => RatingScreen());
      case reviewScreen:
        return MaterialPageRoute(builder: (_) => ReviewScreen());
      case favoriteScreen:
        return MaterialPageRoute(builder: (_) => FavoriteScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
       
    }
  }
}
