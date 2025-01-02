import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../utils/app_colors.dart';


class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Olivia Turner, M.D.',
      'specialty': 'Dermato-Endocrinology',
      'rating': 5.0,
      'image': 'assets/images/doctor1.jpg',
    },
    {
      'name': 'Dr. Alexander Bennett, Ph.D.',
      'specialty': 'Dermato-Genetics',
      'rating': 5.0,
      'image': 'assets/images/doctor2.jpg',
    },
    {
      'name': 'Dr. Sophia Martinez, Ph.D.',
      'specialty': 'Cosmetic Bioengineering',
      'rating': 4.9,
      'image': 'assets/images/doctor3.jpg',
    },
    {
      'name': 'Dr. Michael Davidson, M.D.',
      'specialty': 'Solar Dermatology',
      'rating': 4.8,
      'image': 'assets/images/doctor4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text(
          'Rating',
          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,color: AppColors.primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined,color: AppColors.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'A - Z',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return DoctorCard(
                  name: doctor['name'],
                  specialty: doctor['specialty'],
                  rating: doctor['rating'],
                  imageUrl: doctor['image'],
                );
              },
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
        _buildNavBarItem(context,Icons.home, 0),
        _buildNavBarItem(context,Icons.chat_bubble_outline, 1),
        _buildNavBarItem(context,Icons.person_outline, 2),
        _buildNavBarItem(context,Icons.calendar_today_outlined, 3),
      ],
    ),
  );
}

Widget _buildNavBarItem(BuildContext context, IconData icon, int index, {bool hasNotification = false}) {
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
        Navigator.pushNamed(context, AppRoutes.appoinments);
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
}



class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;

  const DoctorCard({
    Key? key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.white),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info, color: AppColors.primaryColor),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today, color: AppColors.primaryColor),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: AppColors.primaryColor),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}