import 'package:flutter/material.dart';
import 'package:life_balance/utils/app_colors.dart';
import 'package:life_balance/firebase/notification_helper.dart';
import 'package:life_balance/routes/routes.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _currentIndex = 0;
  Map<String, List<Map<String, dynamic>>> _notifications = {};
  final NotificationsHelper _helper = NotificationsHelper();


  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }


  Future<void> _fetchNotifications() async {
    try {
      final notifications = await _helper.fetchNotifications();
      setState(() {
        _notifications = notifications;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        for (var dateKey in _notifications.keys) ...[
                          _buildSectionLabel(dateKey),
                          const SizedBox(height: 10),
                          for (var notification in _notifications[dateKey]!) ...[
                            _buildNotificationItem(
                              avatarColor: notification['avatarColor'],
                              title: notification['title'],
                              description: notification['description'],
                              time: notification['time'],
                            ),
                            const SizedBox(height: 30),
                          ]
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }


  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Center(
              child: Text(
                'Notification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionChip('Mark all'),
            _buildActionChip('News'),
          ],
        ),
      ],

    );
  }

  Widget _buildActionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.hintColor,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 20,
        fontFamily: 'League Spartan',
        fontWeight: FontWeight.w400,
      ),
    );
  }


  Widget _buildNotificationItem({
    required Color avatarColor,
    required String title,
    required String description,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22.5,
          backgroundColor: avatarColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          time,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }


  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      height: 70,
      decoration: BoxDecoration(
        color:  AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
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
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: isSelected ? Colors.white : Colors.white70,
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
    );
  }
}

