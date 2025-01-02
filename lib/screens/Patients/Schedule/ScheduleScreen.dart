import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_balance/utils/app_colors.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:intl/intl.dart';

import '../../../firebase/notification_helper.dart';
import '../Chat/ChatScreen.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int _selectedDateIndex = -1;
  int _selectedTimeIndex = -1;
  int _currentIndex = 1;
  DateTime currentDate = DateTime.now();
  final NotificationsHelper _notificationsHelper = NotificationsHelper();


  final List<DateTime> _daysOfMonth = [];

  // Available time slots
  final List<String> timeSlots = [
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "11:30 AM",
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _generateDaysOfMonth();
  }

  void _generateDaysOfMonth() {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    for (int i = 0; i < lastDayOfMonth.day; i++) {
      _daysOfMonth.add(firstDayOfMonth.add(Duration(days: i)));
    }

    _selectedDateIndex = _daysOfMonth.indexWhere((date) =>
    date.day == currentDate.day &&
        date.month == currentDate.month &&
        date.year == currentDate.year);
  }

  void _createAppointment() async {
    if (_selectedDateIndex == -1 || _selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time.')),
      );
      return;
    }

    final selectedDate = _daysOfMonth[_selectedDateIndex];
    final selectedTime = timeSlots[_selectedTimeIndex];
    final combinedDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
      "${DateFormat('yyyy-MM-dd').format(selectedDate)} $selectedTime",
    );
    final userId = "currentUserId"; // Replace with actual user ID from auth
    final doctorId = "Dr. Olivia Turner, M.D."; // Replace with actual doctor ID

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          // .doc(userId)
          // .collection('userAppointments')
          .add({
        'appointmentDate': combinedDateTime.toIso8601String(),
        'doctorId': doctorId,
        'userId': userId,
        'status': 'upcoming',
      });
      await sendScheduleNotification(doctorId, combinedDateTime.toIso8601String());


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  Future<void> sendScheduleNotification(String doctorName, String appointmentDate) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception("User is not authenticated.");
    }

    final Map<String, dynamic> scheduleNotification = {
      'title': 'Appointment Scheduled',
      'description': 'Your appointment with $doctorName on $appointmentDate has been confirmed.',
    };

    await _notificationsHelper.saveNotification(currentUserId, scheduleNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),

              // Date Selection
              _buildDateScrollView(),

              // Available Time Section
              _buildAvailableTime(),

              _buildSectionDivider(),

              // Patient Details Section
              _buildPatientDetails(),

              _buildSectionDivider(),

              // Problem Description Section
              _buildProblemDescription(),

              // Proceed Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: ElevatedButton(
                  onPressed: _createAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Proceed',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
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

  Widget _buildDateScrollView() {
    return SizedBox(
      height: 90,
      child: Container(
        color: AppColors.secondaryColor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _daysOfMonth.length,
          itemBuilder: (context, index) {
            bool isSelected = index == _selectedDateIndex;
            final date = _daysOfMonth[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDateIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${date.day}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.buttonTextColor
                              : Colors.black),
                    ),
                    Text(
                      DateFormat('E').format(date).toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? AppColors.buttonTextColor
                              : Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryColor,
              size: 24.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Dr. Olivia Turner, M.D.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonTextColor,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              IconButton(icon: Icon( Icons.chat, color: AppColors.primaryColor, size: 28),
                  onPressed:(){
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                // doctorId: 'yKYJAuW5jaSKm11dWFWl9nIfoe52',
                                doctorId: 'lmOjGXn7ZoMmTJQeLZrYY9nY5rE3',

                              ),
                            ),
                          );
                        }),
              const SizedBox(width: 8),
              Icon(Icons.favorite_border, color: AppColors.primaryColor, size: 28),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildAvailableTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Time",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(timeSlots.length, (index) {
              bool isSelected = _selectedTimeIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeIndex = index;
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    timeSlots[index],
                    style: TextStyle(
                      color: isSelected ? AppColors.buttonTextColor : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 10),
          _buildTextFieldPatient("Full Name", "Jane Doe"),
          _buildTextFieldPatient("Age", "30"),
          _buildGenderSelection(),
        ],
      ),
    );
  }

  Widget _buildTextFieldPatient(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label positioned on top
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor),
          ),
          const SizedBox(height: 2),

          TextField(
            style: TextStyle(color: AppColors.hintColor),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: AppColors.hintColor),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildGenderButton("Male"),
        _buildGenderButton("Female", isSelected: true),
        _buildGenderButton("Other"),
      ],
    );
  }

  Widget _buildGenderButton(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        selectedColor: AppColors.primaryColor,
        backgroundColor: AppColors.inputBackground,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.buttonTextColor : AppColors.hintColor,
        ),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      ),
    );
  }

  Widget _buildProblemDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Describe your problem",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppColors.primaryColor),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter Your Problem Here...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  Widget _buildSectionDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Divider(
        color: AppColors.primaryColor,
        thickness: 1.5,
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
