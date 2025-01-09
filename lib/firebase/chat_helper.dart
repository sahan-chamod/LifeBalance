import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatHelper {
  final DatabaseReference _chatsRef = FirebaseDatabase.instance.ref().child('chats');

  Future<String?> getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<String?> checkIfDefaultNameIsNull(String? dynamicName, String? doctorId) async {
    if (dynamicName == null) {
      final doctor = await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();
      return doctor['name'];
    }
    return dynamicName;
  }

  Future<String?> checkAndCreateChat(String userId, String? doctorId) async {
    final userChats = await _chatsRef.get();

    if (userChats.exists) {
      for (final chat in userChats.children) {
        final participants = chat.child('participants').value as Map<dynamic, dynamic>;

        if (participants.containsKey(doctorId) && participants.containsKey(userId)) {
          return chat.key;
        }
      }
    }
    return await createNewChat(userId, doctorId);
  }

  Future<String?> createNewChat(String userId, String? doctorId) async {
    final newChatId = DateTime.now().millisecondsSinceEpoch.toString();
    final doctor = await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();
    final user = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final doctorName = doctor['name'];
    final userName = user['fullName'];

    final newChat = {
      'participants': {
        userId: userName,
        doctorId!: doctorName,
      },
      'messages': {},
    };

    await _chatsRef.child(newChatId).set(newChat);
    return newChatId;
  }

  Stream<List<Map<String, dynamic>>> listenToMessages(String chatId) {
    return _chatsRef
        .child(chatId)
        .child('messages')
        .orderByChild('time')
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((e) {
        final value = e.value as Map<dynamic, dynamic>;
        return {
          'id': e.key,
          'text': value['text'],
          'senderId': value['senderId'],
          'time': value['time'],
        };
      }).toList()
        ..sort((a, b) => a['time'].compareTo(b['time']));
    });
  }

  Future<void> sendMessage(String chatId, String userId, String text) async {
    if (text.trim().isEmpty) return;

    final message = {
      'text': text,
      'senderId': userId,
      'time': DateTime.now().toIso8601String(),
    };

    await _chatsRef.child(chatId).child('messages').push().set(message);
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
      final messageRef = _chatsRef.child(chatId).child('messages').child(messageId);
      await messageRef.remove();
  }
}