import 'package:flutter/material.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: SafeArea(
          child:SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Column(
                    children: [
                      CustomListTitle(
                        icon: Icons.password,
                        title: 'Password Manager',
                        route: AppRoutes.password,
                      ),
                      CustomListTitle(
                        icon: Icons.delete,
                        title: 'Delete Account',
                        route: AppRoutes.password,
                      ),
                    ],
                  )
                ],
              ),
          ),
      )
      ),
    );
  }
}


class CustomListTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const CustomListTitle({super.key, required this.icon, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.blueGrey,
        size: 18,
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
