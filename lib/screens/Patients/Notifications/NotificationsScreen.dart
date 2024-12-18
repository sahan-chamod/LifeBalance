import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        _buildSectionLabel('Today'),
                        const SizedBox(height: 10),
                        _buildNotificationItem(
                          avatarColor: const Color(0xFF225FFF),
                          title: 'Scheduled appointment',
                          description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          time: '2 m',
                        ),
                        const SizedBox(height: 30),
                        _buildSectionLabel('Yesterday'),
                        const SizedBox(height: 10),
                        _buildNotificationItem(
                          avatarColor: const Color(0xFF225FFF),
                          title: 'Follow-up Reminder',
                          description: 'Your next follow-up is due tomorrow.',
                          time: '1 d',
                        ),
                        const SizedBox(height: 30),
                        _buildSectionLabel('15 April'),
                        const SizedBox(height: 10),
                        _buildNotificationItem(
                          avatarColor: const Color(0xFF225FFF),
                          title: 'Health Tips',
                          description: 'Drink at least 2 liters of water daily.',
                          time: '3 d',
                        ),
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
              icon: Icon(Icons.arrow_back_ios, color: Color(0xFF225FFF)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Center(
              child: Text(
                'Notification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF225FFF),
                  fontSize: 24,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 48), // Placeholder to align title in the center
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
        color: const Color(0xFFC9D5FF),
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
        color: Color(0xFF225FFF),
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
        color: const Color(0xFF225FFF),
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
          _buildNavBarItem(Icons.person_outline, 2, hasNotification: true),
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

