import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/favorite_helper.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Patients/Schedule/ScheduleScreen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  int _currentIndex = 0;
  final FavoriteHelper _favoriteHelper = FavoriteHelper();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Doctors',
          style: TextStyle(
            color: Color(0xFF2260FF),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2260FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'A - Z',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.doctorRating);
                  },
                  icon: const Icon(Icons.star_border, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DoctorCard(
                    name: 'Dr. Alexander Bennett, Ph.D.',
                    specialty: 'Dermato-Genetics',
                    imagePath: 'assets/images/doctor3.jpg',
                    favoriteHelper: _favoriteHelper,
                    userId:userId!,
                  ),
                  DoctorCard(
                    name: 'Dr. Michael Davidson, M.D.',
                    specialty: 'Solar Dermatology',
                    imagePath: 'assets/images/doctor2.jpg',
                    favoriteHelper: _favoriteHelper,
                    userId:userId!,

                  ),
                  DoctorCard(
                    name: 'Dr. Olivia Turner, M.D.',
                    specialty: 'Dermato-Endocrinology',
                    imagePath: 'assets/images/doctor1.jpg',
                    favoriteHelper: _favoriteHelper,
                    userId:userId!,

                  ),
                  DoctorCard(
                    name: 'Dr. Sophia Martinez, Ph.D.',
                    specialty: 'Cosmetic Bioengineering',
                    imagePath: 'assets/images/doctor4.jpg',
                    favoriteHelper: _favoriteHelper,
                    userId:userId!,

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(context) {
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
          _buildNavBarItem(context, Icons.home, 0),
          _buildNavBarItem(context, Icons.chat_bubble_outline, 1),
          _buildNavBarItem(context, Icons.person_outline, 2),
          _buildNavBarItem(context, Icons.calendar_today_outlined, 3),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushNamed(context, AppRoutes.home);
        }
        if (index == 1) {
          Navigator.pushNamed(context, AppRoutes.chatlist);
        }
        if (index == 2) {
          Navigator.pushNamed(context, AppRoutes.profile);
        }
        if (index == 3) {
          Navigator.pushNamed(context, AppRoutes.appoinments);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: _currentIndex == index ? Colors.white : Colors.white70,
          ),
        ],
      ),
    );
  }
}
class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imagePath;
  final FavoriteHelper favoriteHelper;
  final String userId;


  const DoctorCard({
    Key? key,
    required this.name,
    required this.specialty,
    required this.imagePath,
    required this.favoriteHelper,
    required this.userId,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.doctorInfo);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2260FF),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Info',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.grey),
                      onPressed: () {
                        favoriteHelper.saveDoctor(userId:userId,name: name,designation: 'Professional Doctor',specialization: specialty,image: imagePath);
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.calendar_month_outlined, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Schedule(
                              doctorName: name,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
