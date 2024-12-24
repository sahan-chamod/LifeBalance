import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


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



