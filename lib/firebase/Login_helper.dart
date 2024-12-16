import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  Future<String?> getUserCollection(String email) async {
    try {
      var userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (userDoc.docs.isNotEmpty) {
        return 'users';
      }

      var doctorDoc = await _firestore
          .collection('doctors')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (doctorDoc.docs.isNotEmpty) {
        return 'doctors';
      }

      var adminDoc = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (adminDoc.docs.isNotEmpty) {
        return 'admin';
      }

      return null;
    } catch (e) {
      throw Exception("Error checking user collection: ${e.toString()}");
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}
