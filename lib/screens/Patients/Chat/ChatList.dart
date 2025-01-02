import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';
import 'ChatScreen.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final DatabaseReference _chatsRef = FirebaseDatabase.instance.ref().child('chats');
  List<Map<String, dynamic>> _chatList = [];
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    if (currentUserId == null) return;

    // Listen for all chats
    _chatsRef.onValue.listen((event) {
      final allChats = event.snapshot.value as Map<dynamic, dynamic>? ?? {};

      final relevantChats = <Map<String, dynamic>>[];

      // Iterate over all the chats
      allChats.forEach((chatId, chatData) {
        final participants = chatData['participants'] as Map<dynamic, dynamic>;

        if (participants.containsKey(currentUserId)) {
          final otherParticipants = participants.entries
              .where((entry) => entry.key != currentUserId)
              .map((entry) => entry.value)
              .join(', ');

          final messages = chatData['messages'] as Map<dynamic, dynamic>? ?? {};
          final lastMessage = messages.entries.isNotEmpty
              ? messages.entries.last.value['text']
              : 'No messages yet';

          final time = messages.entries.isNotEmpty
              ? messages.entries.last.value['time']
              : '';

          relevantChats.add({
            'chatId': chatId,
            'participants': otherParticipants,
            'lastMessage': lastMessage,
            'time': time,
          });
        }
      });

      setState(() {
        _chatList = relevantChats;
      });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: _chatList.isEmpty
                  ? const Center(
                child: Text(
                  'No chats available',
                  style: TextStyle(color: Colors.black),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _chatList.length,
                itemBuilder: (context, index) {
                  return _buildChatCard(_chatList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return SafeArea(
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Center(
              child: Text(
                'Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, 0),
          _buildNavBarItem(Icons.chat_bubble_outline, 1),
          _buildNavBarItem(Icons.person_outline, 2),
          _buildNavBarItem(Icons.calendar_today_outlined, 3),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index, {bool hasNotification = false}) {
    return GestureDetector(
      onTap: () {
        if(index==0){
          Navigator.pushNamed(context, AppRoutes.home);
        }
        if(index==1){
          Navigator.pushNamed(context, AppRoutes.chatlist);
        }
        if(index==2){
          Navigator.pushNamed(context, AppRoutes.profile);
        }
        if(index==3){
          Navigator.pushNamed(context, AppRoutes.schedule);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                size: 30,
                color: _currentIndex == index ? Colors.white : Colors.white70,
              ),
              if (hasNotification)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    return Card(
      color: AppColors.secondaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/doctor1.jpg'),
        ),
        title: Text(
          chat['participants'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(chatId: chat['chatId'],dynamicName: chat['participants'],),
              settings: RouteSettings(arguments: {'chatId': chat['chatId']}),
            ),
          );
        },
      ),
    );

  }
}
