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

  Future<void> delete(int id)async{
    await _controller.delete(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Record deleted successfully",style: TextStyle(
            fontSize:20.0
        ),),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
    refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
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
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            ...data.map((toElement)=>_alegi(toElement,delete))
                          ],
                        ),
                      ),
                    ],
          ),
          )),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRoutes.addFoodAllergy);
          if (result == true) {
            refreshItems();
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add New",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}

Widget _alegi(Allergic allergic,delete) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            allergic.title,
            style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 19.0
            ),
          ),
          TextButton(onPressed: ()async{
            print(allergic.toMap());
            await  delete(allergic.id);
          }, child: Icon(Icons.delete,color: Colors.red,))
        ],
      ),
      const SizedBox(height: 20),
      Text(
        allergic.description,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
      const SizedBox(height: 30),
    ],
  );
}