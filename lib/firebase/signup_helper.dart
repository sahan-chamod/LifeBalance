import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required String fullName,
    required String email,
    required String password,
    required String mobileNumber,
    required String dateOfBirth,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'password': password,
        'mobileNumber': mobileNumber,
        'dateOfBirth': dateOfBirth,
        'createdAt': Timestamp.now(),
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'The email address is already in use.';
      } else if (e.code == 'weak-password') {
        throw 'The password is too weak.';
      } else {
        throw 'Sign up failed. Please try again.';
      }
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
