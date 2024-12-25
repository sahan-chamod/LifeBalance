import 'package:flutter/material.dart';
import 'package:life_balance/db/allergicModel.dart';
import 'package:life_balance/db/db.dart';
import 'package:life_balance/utils/app_colors.dart';

class AddMediAlegic extends StatefulWidget {
  const AddMediAlegic({super.key});

  @override
  State<AddMediAlegic> createState() => _AddMediAlegicState();
}

class _AddMediAlegicState extends State<AddMediAlegic> {

  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _descriptionController=TextEditingController();
  final _databaseHelper= DatabaseHelper();

  Future<void> addAllergic()async{
    if(_titleController.text.isEmpty){
      return null;
    }

    if(_descriptionController.text.isEmpty){
      return null;
    }

    final allergic=Allergic(
        title: _titleController.text,
        description: _descriptionController.text,
        created: DateTime.now());
    _databaseHelper.insertMedicalAllergic(allergic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
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
                      "Add Medical Allergy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),

                // Spacer to balance alignment
              ],
            ),
            SizedBox(height: 20,),
            _inputFields("Allergy",_titleController),
            SizedBox(height: 20,),
            _inputFields("Allergy Description",_descriptionController),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: (){
                    addAllergic();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF225FFF),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                  ),
                  child:const Text(
                    "Save Allergy",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )),])
          ],
        ),
      )),
    );
  }
}

Widget _inputFields(String label, TextEditingController controller,
    {TextInputType keyboardType = TextInputType.text}){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style:const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8.0,),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFECF1FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      )
    ],
  );
}
