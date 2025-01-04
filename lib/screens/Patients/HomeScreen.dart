import 'dart:io';
import 'package:life_balance/firebase/user_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:life_balance/routes/routes.dart';
import '../../utils/app_colors.dart';
import 'package:life_balance/provider/user.proivder.dart';
import 'Chat/ChatScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late UserProvider userProvider;
  File? file;
  String? name;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.userOtherDetails();

    // if (userProvider.user?.displayName != null) {
    name = userProvider.user?.displayName ?? "";
    print("home get");
    if (userProvider.profileImage.isNotEmpty) {
      _loadImage(userProvider.profileImage);
    }
  }

  Future<void> _loadImage(String? url) async {
    final filePath = '$url';
    final imageFile = await fetchImage(filePath);
    print(imageFile);
    setState(() {
      file = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondaryColor,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: file != null ? FileImage(file!) : null,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, Welcome Back",
                style: TextStyle(fontSize: 16, color: AppColors.textColor)),
            Text(name ?? "",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          // Icon(Icons.notifications_none, color: AppColors.textColor, size: 28),
          GestureDetector(
            onTap: () {
              // Navigate to the notification page when the icon is tapped
              Navigator.pushNamed(
                context, AppRoutes.notifications,
                // MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            child: Icon(Icons.notifications_none,
                color: AppColors.textColor, size: 28),
          ),
          SizedBox(width: 12),
          Icon(Icons.settings, color: AppColors.textColor, size: 28),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          _buildTopSection(context),
          _buildDateScrollView(),
          _buildTodaySection(),
          Expanded(
            child: ListView(
              children: [
                _buildDoctorCard(context, 'assets/images/doctor1.jpg',
                    "Dr. Olivia Turner, M.D.", "Dermato-Endocrinology", 5.0, 0),
                _buildDoctorCard(
                    context,
                    'assets/images/doctor2.jpg',
                    "Dr. Alexander Bennett, Ph.D.",
                    "Dermato-Granulese",
                    4.5,
                    1),
                _buildDoctorCard(
                    context,
                    'assets/images/doctor3.jpg',
                    "Dr. Sophia Martinez, Ph.D.",
                    "Cosmetic Bioengineering",
                    5.0,
                    2),
                _buildDoctorCard(context, 'assets/images/doctor4.jpg',
                    "Dr. Michael Davidson, M.D.", "Nano-Dermatology", 4.8, 3),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index,
      {bool hasNotification = false}) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        if (index == 1) {
          Navigator.pushNamed(context, AppRoutes.chatlist);
        }
        if (index == 2) {
          Navigator.pushNamed(context, AppRoutes.profile);
        }
        if (index == 3) {
          Navigator.pushNamed(context, AppRoutes.appoinments);
        }
        print(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
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
        ],
      ),
    );
  }
}

Widget _buildTopSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: Row(
      children: [
        _buildTopButton(context, Icons.favorite_border, "Doctors", 0),
        const SizedBox(width: 12),
        _buildTopButton(context, Icons.star_border, "Favorite", 1),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search, color: AppColors.textColor),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTopButton(
    BuildContext context, IconData icon, String label, int index) {
  return GestureDetector(
    onTap: () {
      if (index == 0) {
        Navigator.pushNamed(context, AppRoutes.doctorsScreen);
      } else if (index == 1) {
        Navigator.pushNamed(context, AppRoutes.favoriteScreen);
      }
    },
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.buttonColor,
          radius: 24,
          child: Icon(icon, color: AppColors.buttonTextColor, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textColor),
        ),
      ],
    ),
  );
}

Widget _buildDateScrollView() {
  return SizedBox(
    height: 90,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, index) {
        bool isSelected = index == 2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primaryColor : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${9 + index}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.buttonTextColor
                          : Colors.black)),
              Text(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"][index],
                  style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.buttonTextColor
                          : Colors.black)),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildTodaySection() {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: const Text(
      "11 Wednesday - Today",
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor),
    ),
  );
}

Widget _buildDoctorCard(BuildContext context, String imagePath, String name,
    String specialty, double rating, int index) {
  return GestureDetector(
    onTap: () {
      if (index == 0) {
        Navigator.pushNamed(context, AppRoutes.doctorInfo);
      } else if (index == 1) {
        // Navigator.pushNamed(context, AppRoutes.favoriteScreen);
      } else if (index == 2) {}
    },
    child: Card(
      color: AppColors.secondaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle:
            Text(specialty, style: const TextStyle(color: AppColors.textColor)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            Text("$rating",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    ),
  );
}
