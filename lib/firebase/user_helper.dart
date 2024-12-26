import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_balance/db/ReportsModel.dart';

User? _user = FirebaseAuth.instance.currentUser;

Future<void>updatePassword(String oldPassword,String newPassword,BuildContext context, clearTheForms)async{
  User? user= FirebaseAuth.instance.currentUser;
  try{
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar( content: Text(
            "Password updated successfully",
            style: TextStyle(fontSize: 20.0),
          ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),));
      clearTheForms();
    }
  }on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.code,
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }


}

Future<String?> uploadImage(String filePath) async {
  final url = Uri.parse('https://api.bytescale.com/v2/accounts/FW25cKz/uploads/form_data');
  final file = File(filePath);

  if (!file.existsSync()) {
    print('Error: File does not exist at the specified path.');
    return null;
  }

  var request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer public_FW25cKzG2fYwSFmw6WeTMeri9U5z'
    ..files.add(await http.MultipartFile.fromPath('file', filePath));

  try {

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      final decodedJson = json.decode(responseData);
      if (decodedJson['files'] != null && decodedJson['files'].isNotEmpty) {
        final fileUrl = decodedJson['files'][0]['fileUrl'];
        print('File URL: $fileUrl');
        return fileUrl;
      } else {
        print('Error: No file URL found in the response.');
        return null;
      }
    } else {
      print('Failed to upload file. Status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error uploading file: $e');
    return null;
  }
}

Future<File?> fetchImage(String filePath) async {
  final url = Uri.parse(filePath);
  final headers = {
    'Authorization': 'Bearer public_FW25cKzG2fYwSFmw6WeTMeri9U5z',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('Image fetched successfully.');

      // Create a temporary file to save the image
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/${filePath.split('/').last}');

      // Write the bytes to the file
      await tempFile.writeAsBytes(response.bodyBytes);

      return tempFile;
    } else {

      print('Failed to fetch image. Status: ${response}');
      return null;
    }
  } catch (e) {
    print('Error fetching image: $e');
    return null;
  }
}


Future<List<ReportsModel>> fetchAllDocs()async{
  try{
    CollectionReference reports = FirebaseFirestore.instance.collection('reports');
    QuerySnapshot querySnapshot = await reports.where('userId', isEqualTo: _user?.uid).get();
    List<ReportsModel> documents = querySnapshot.docs.map((doc) {
      return ReportsModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    return documents;

  }catch(e){
    return [];
  }

}

Future<void>uploadDocument(String? filePath)async{
  CollectionReference reports = FirebaseFirestore.instance.collection('reports');
  Map<String, dynamic> data = {
    'userId': _user?.uid,
    'filePath': filePath,
  };
  await reports.add(data);
}
