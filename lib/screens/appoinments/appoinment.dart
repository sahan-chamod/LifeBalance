// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../utils/app_colors.dart';
// import 'upcoming_appointments.dart';

// class Appointments extends StatelessWidget {
//   const Appointments({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Appointment UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AppointmentScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class AppointmentScreen extends StatefulWidget {
//   const AppointmentScreen({Key? key}) : super(key: key);

//   @override
//   _AppointmentScreenState createState() => _AppointmentScreenState();
// }

// class _AppointmentScreenState extends State<AppointmentScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         title: const Text(
//           'All Appointment',
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: AppColors.secondaryColor,
//           labelColor: AppColors.secondaryColor,
//           unselectedLabelColor: AppColors.textColor,
//           tabs: const [
//             Tab(text: 'Complete'),
//             Tab(text: 'Upcoming'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           AppointmentList(),
//           const UpcomingAppointmentsPage(),
//         ],
//       ),
//     );
//   }
// }

// class AppointmentList extends StatelessWidget {
//   final List<Map<String, String>> appointments = [
//     {
//       'id': '1',
//       'name': 'Dr. Olivia Turner, M.D.',
//       'specialty': 'Dermato-Endocrinology',
//       'rating': '5',
//     },
//     {
//       'id': '2',
//       'name': 'Dr. Alexander Bennett, Ph.D.',
//       'specialty': 'Dermato-Genetics',
//       'rating': '4',
//     },
//     {
//       'id': '3',
//       'name': 'Dr. Sophia Martinez, M.D.',
//       'specialty': 'Cosmetic Bioengineering',
//       'rating': '5',
//     },
//   ];

//   Future<void> bookAppointment(BuildContext context, String doctorId) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );

//     if (selectedDate == null) return;

//     TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (selectedTime == null) return;

//     final appointmentDateTime = DateTime(
//       selectedDate.year,
//       selectedDate.month,
//       selectedDate.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );

//     final firestore = FirebaseFirestore.instance;
//     await firestore.collection('appointments').add({
//       'doctorId': doctorId,
//       'userId': 'currentUserId',
//       'appointmentDate': appointmentDateTime.toIso8601String(),
//       'status': 'upcoming', // Add status field for appointment state
//     });

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Success'),
//           content: const Text('Appointment booked successfully!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: appointments.length,
//       itemBuilder: (context, index) {
//         final appointment = appointments[index];
//         return Card(
//           color: AppColors.secondaryBackground,
//           margin: const EdgeInsets.all(10),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage:
//                       NetworkImage('https://via.placeholder.com/150'),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         appointment['name']!,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         appointment['specialty']!,
//                         style: const TextStyle(color: AppColors.textColor),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await bookAppointment(context, appointment['id']!);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.buttonColor,
//                   ),
//                   child: const Text(
//                     'Re-Book',
//                     style: TextStyle(color: AppColors.buttonTextColor),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';

class Appointments extends StatelessWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AppointmentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'All Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: AppColors.secondaryColor),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondaryColor,
          labelColor: AppColors.secondaryColor,
          unselectedLabelColor: AppColors.textColor,
          tabs: const [
            Tab(text: 'Complete'),
            Tab(text: 'Upcoming'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AppointmentList(),
          Center(child: Text('Upcoming Appointments')),
        ],
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  const AppointmentList({Key? key}) : super(key: key);

  final List<Map<String, String>> appointments = const [
    {
      'id': '1',
      'name': 'Dr. Olivia Turner, M.D.',
      'specialty': 'Dermato-Endocrinology',
      'rating': '5',
    },
    {
      'id': '2',
      'name': 'Dr. Alexander Bennett, Ph.D.',
      'specialty': 'Dermato-Genetics',
      'rating': '4',
    },
    {
      'id': '3',
      'name': 'Dr. Sophia Martinez, M.D.',
      'specialty': 'Cosmetic Bioengineering',
      'rating': '5',
    },
  ];

  Future<void> _bookAppointment(BuildContext context, String doctorId) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    final appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': doctorId,
        'userId': 'currentUserId', // Replace with actual user ID
        'appointmentDate': appointmentDateTime.toIso8601String(),
        'status': 'upcoming',
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Appointment booked successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          color: AppColors.secondaryBackground,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      const NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        appointment['specialty']!,
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _bookAppointment(context, appointment['id']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                      ),
                      child: const Text(
                        'Re-Book',
                        style: TextStyle(color: AppColors.buttonTextColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.reviewScreen),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Review'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
