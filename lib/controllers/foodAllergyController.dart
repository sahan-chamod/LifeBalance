import 'package:life_balance/db/allergicModel.dart';
import 'package:life_balance/db/db.dart';

class FoodAllergyController{
  final dbHelper=DatabaseHelper();

  Future<List<Allergic>>fetchAllergies()async{
    return await dbHelper.getFoodAllergies();
  }

  Future<void>insertNewAllergy(Allergic allergy)async{
    return await dbHelper.insertFoodAllergy(allergy);
  }


}
