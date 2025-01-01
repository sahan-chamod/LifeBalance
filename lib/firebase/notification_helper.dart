import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<Map<String, dynamic>>>> fetchNotifications() async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception("User is not authenticated.");
    }

    final userNotifications = _firestore
        .collection('notifications')
        .doc(currentUserId)
        .collection('user_notifications');

    final QuerySnapshot snapshot =
    await userNotifications.orderBy('timestamp', descending: true).get();

    Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['timestamp'] == null) continue;

      final DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
      final String dateKey = "${timestamp.day} ${_monthName(timestamp.month)}";

      groupedNotifications.putIfAbsent(dateKey, () => []);
      groupedNotifications[dateKey]!.add({
        'title': data['title'] ?? 'No Title',
        'description': data['description'] ?? 'No Description',
        'time': _formatTimeAgo(timestamp),
        'avatarColor': const Color(0xFF225FFF),
      });
    }

    return groupedNotifications;
  }

  Future<void> saveNotification(String userId, Map<String, dynamic> notification) async {
    final userNotifications = _firestore
        .collection('notifications')
        .doc(userId)
        .collection('user_notifications');

    await userNotifications.add({
      ...notification,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveDummyNotification() async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception("User is not authenticated.");
    }

    final Map<String, dynamic> dummyNotification = {
      'title': 'Test Notification',
      'description': 'This is a dummy notification for testing purposes.',
    };

    await saveNotification(currentUserId, dummyNotification);
  }

  String _formatTimeAgo(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} m";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} h";
    } else {
      return "${difference.inDays} d";
    }
  }

  String _monthName(int month) {
    const List<String> months = [
      "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}
