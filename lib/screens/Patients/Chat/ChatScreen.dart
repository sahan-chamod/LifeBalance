import 'package:flutter/material.dart';
import 'package:life_balance/firebase/chat_helper.dart';
import 'package:life_balance/utils/app_colors.dart';

class Chat extends StatefulWidget {
  final String? chatId;
  final String? doctorId;
  final String? dynamicName;

  const Chat({this.chatId, this.doctorId, this.dynamicName, Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatHelper _chatHelper = ChatHelper();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String? _userId;
  String? _currentChatId;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    _userId = await _chatHelper.getUserId();
    if (_userId != null) {
      if (widget.chatId == null) {
        _currentChatId = await _chatHelper.checkAndCreateChat(_userId!, widget.doctorId);
      } else {
        _currentChatId = widget.chatId;
      }
      _listenToMessages();
    }
  }

  void _listenToMessages() {
    if (_currentChatId != null) {
      _chatHelper.listenToMessages(_currentChatId!).listen((messages) {
        setState(() {
          _messages = messages;

        });
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(widget.dynamicName),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: _buildChatArea(),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildHeader(String? dynamicName) {
    return SafeArea(
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: FutureBuilder<String?>(
                  future: _chatHelper.checkIfDefaultNameIsNull(dynamicName, widget.doctorId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.video_call, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildChatBubble(
          message['text'],
          senderId: message['senderId'],
          time: message['time'],
        );
      },
    );
  }

  Widget _buildChatBubble(String text, {required String senderId, required String time}) {
    final isSender = senderId == _userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isSender ? AppColors.primaryColor : const Color(0xFFECF1FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSender ? 16 : 0),
                  topRight: Radius.circular(isSender ? 0 : 16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isSender ? Colors.white : const Color(0xFF225FFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                time.substring(11, 19),
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: AppColors.textColor),
                filled: true,
                fillColor: AppColors.inputBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_currentChatId != null && _userId != null) {
      final text = _messageController.text;
      _chatHelper.sendMessage(_currentChatId!, _userId!, text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
