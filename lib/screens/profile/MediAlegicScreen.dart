import 'package:flutter/material.dart';
import 'package:life_balance/controllers/medicalAllergicController.dart';
import 'package:life_balance/db/allergicModel.dart';
import 'package:life_balance/db/db.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';

class MediAlegicScreen extends StatefulWidget {
  const MediAlegicScreen({super.key});

  @override
  State<MediAlegicScreen> createState() => _MediAlegicScreenState();
}

class _MediAlegicScreenState extends State<MediAlegicScreen> {
  final MedicalAllergyController _controller= MedicalAllergyController();
  List<Allergic> data=[];

  @override
  void initState() {
    refreshItems();
    super.initState();
  }


  Future<void> refreshItems() async {
    List<Allergic>datas=await _controller.fetchAllergies();
    setState(() {
      data = datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        "Medical Allergies",
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
                    ...data.map((toElement)=>_alegi(toElement))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, AppRoutes.addMediAlegic);
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

Widget _alegi(Allergic allergic) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        allergic.title,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 19.0
        ),
      ),
      const SizedBox(height: 20),
      Text(
        allergic.description,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 30),
    ],
  );
}
