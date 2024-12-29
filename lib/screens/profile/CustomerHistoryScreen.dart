import 'package:flutter/material.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';

class CustomerHistoryScreen extends StatefulWidget {
  const CustomerHistoryScreen({super.key});

  @override
  State<CustomerHistoryScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<CustomerHistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "Customer History",
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
                        icon: Icons.report_problem,
                        title: 'Report History',
                        route: AppRoutes.reportHistory,
                      ),
                      CustomListTitle(
                        icon: Icons.heart_broken,
                        title: 'Medi-Allergies',
                        route: AppRoutes.mediAlegic,
                      ),
                      CustomListTitle(
                        icon: Icons.food_bank,
                        title: 'Food-Allergies',
                        route: AppRoutes.foodAllergy,
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
