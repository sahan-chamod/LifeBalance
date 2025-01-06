import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDoctor({
    required String userId,
    required String name,
    required String designation,
    required String specialization,
    required String image,
  }) async {
    final doctor = {
      'name': name,
      'designation': designation,
      'specialization': specialization,
      'image':image,

    };
    await _firestore.collection('favourites').doc(userId).collection('doctorDetails').add(doctor);
  }

  Future<void> removeDoctor({
    required String userId,
    required String docId,
  }) async {
    await _firestore.collection('favourites').doc(userId).collection('doctorDetails').doc(docId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors(String userId) async {
    final snapshot = await _firestore.collection('favourites').doc(userId).collection('doctorDetails').get();
    return snapshot.docs
        .map((doc) => {
      ...doc.data(),
      'id': doc.id,
    })
        .toList();
  }
}