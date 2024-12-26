import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _user = FirebaseAuth.instance.currentUser;
  String? dateOfBirth;
  String? mobileNumber;
  String profileImage="";

  User? get user => _user;



  Future<void> updateUser(String newDisplayName, String phoneNumber, String dob,BuildContext context) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(_user?.uid);
      if (_user != null) {

        if (newDisplayName.isNotEmpty) {
          await _user!.updateDisplayName(newDisplayName);
        }

        if (phoneNumber.isNotEmpty) {
          await userRef.set({
            'mobileNumber': phoneNumber,
          }, SetOptions(merge: true));
        }

        if(dob.isNotEmpty){
          await userRef.set({
            'dateOfBirth': dob,
          }, SetOptions(merge: true));
        }

        await _user!.reload();
        _user = FirebaseAuth.instance.currentUser;

        userOtherDetails();
        notifyListeners();
      }
    } catch (e) {
      print("Error updating user: $e");
    }
  }
  
  Future<void>userOtherDetails()async{
    final userRef = FirebaseFirestore.instance.collection('users').doc(_user?.uid);
    DocumentSnapshot docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      var data = docSnapshot.data() as Map<String, dynamic>;
      dateOfBirth=data["dateOfBirth"];
      mobileNumber=data["mobileNumber"];
      profileImage=data["profileImage"];
      notifyListeners();
    }
  }

  Future<void>updateProfileImage(String path)async{
    final userRef = FirebaseFirestore.instance.collection('users').doc(_user?.uid);
    DocumentSnapshot docSnapshot = await userRef.get();
    if(docSnapshot.exists){
      await userRef.set({
        'profileImage': path,
      }, SetOptions(merge: true));
    }
  }











}
