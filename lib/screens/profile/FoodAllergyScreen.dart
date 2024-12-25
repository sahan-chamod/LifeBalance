import 'package:flutter/material.dart';
import 'package:life_balance/controllers/foodAllergyController.dart';
import 'package:life_balance/db/allergicModel.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';

class FoodAllergyScreen extends StatefulWidget {
  const FoodAllergyScreen({super.key});

  @override
  State<FoodAllergyScreen> createState() => _FoodAllergyScreenState();
}

class _FoodAllergyScreenState extends State<FoodAllergyScreen> {
  List<Allergic> data=[];
  final FoodAllergyController _controller=FoodAllergyController();

  @override
  void initState() {
    refreshItems();
    super.initState();

  }

  Future<void> refreshItems() async {
    List<Allergic>datas=await _controller.fetchAllergies();
    print(datas);
    setState(() {
      data = datas;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(20),
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
                                "Food Allergies",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Spacer to balance alignment
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.addFoodAllergy);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.primaryColor,
                            ),
                          )
                        ],),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            ...data.map((toElement)=>_alegi(toElement))
                          ],
                        ),
                      ),
                    ],
          ),
          )),
    );
  }
}

Widget _alegi(Allergic allergic) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        allergic.title,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      Text(
        allergic.description,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 30),
    ],
  );
}