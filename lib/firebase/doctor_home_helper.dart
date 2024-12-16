import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetching the doctors collection
  Stream<QuerySnapshot> getDoctorsCollection() {
    return _db.collection('doctors').snapshots();
  }

  // Adding a new doctor to the Firestore
  Future<void> addDoctor(Map<String, dynamic> doctorData) async {
    try {
      await _db.collection('doctors').add(doctorData);
    } catch (e) {
      print("Error adding doctor: $e");
      throw e;
    }
  }

  // Deleting a doctor from the Firestore by ID
  Future<void> deleteDoctor(String doctorId) async {
    try {
      await _db.collection('doctors').doc(doctorId).delete();
    } catch (e) {
      print("Error deleting doctor: $e");
      throw e;
    }
  }
}
