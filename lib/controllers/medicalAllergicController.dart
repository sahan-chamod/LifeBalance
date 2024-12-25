import 'package:life_balance/db/allergicModel.dart';
import 'package:life_balance/db/db.dart';

class MedicalAllergyController{
  final dbHelper=DatabaseHelper();

  Future<List<Allergic>>fetchAllergies()async{
    return await dbHelper.getMedicalAllergic();
  }
}