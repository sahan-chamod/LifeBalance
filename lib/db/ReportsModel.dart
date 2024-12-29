class ReportsModel{
 String? filePath;
 String? userId;

 ReportsModel({
   required this.filePath,
   required this.userId
});


 Map<String, dynamic> toMap() {
   return {
     'filePath': filePath,
     'userId': userId,
   };
 }

 factory ReportsModel.fromMap(Map<String, dynamic> map) {
   return ReportsModel(
     filePath: map['filePath'],
     userId: map['userId'],
   );
 }

}