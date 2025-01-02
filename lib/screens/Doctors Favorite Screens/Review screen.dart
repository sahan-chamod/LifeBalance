import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../utils/app_colors.dart';


class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentIndex = 0;
  int rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitReview(String doctorName, int rating, String reviewText) async {
      String reviewId = DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore
          .collection('reviews')
          .doc(doctorName)
          .collection('reviews')
          .doc(reviewId)
          .set({
        'rating': rating,
        'review': reviewText,
        'doctor_name': doctorName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        rating = 0;
      });
      _reviewController.clear();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Review',
          style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/doctor1.jpg'), // Replace with your image asset
            ),
            SizedBox(height: 10),
            Text(
              'Dr. Olivia Turner, M.D.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Dermato-Endocrinology',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter Your Comment Here…',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (rating > 0 && _reviewController.text.isNotEmpty) {
                  await _submitReview(
                    'Dr. Olivia Turner',
                    rating,
                    _reviewController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide a rating and review.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: Text(
                'Add Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
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