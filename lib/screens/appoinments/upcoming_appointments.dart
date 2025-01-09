import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpcomingAppointmentsPage extends StatefulWidget {
  @override
  _UpcomingAppointmentsPageState createState() => _UpcomingAppointmentsPageState();
}

class _UpcomingAppointmentsPageState extends State<UpcomingAppointmentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUpcomingAppointments() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('status', isEqualTo: 'upcoming')
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error retrieving appointments: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUpcomingAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Doctor: ${appointment['name'] ?? 'No Name'}'),
                    subtitle: Text('Date: ${appointment['appointmentDate'] ?? 'No Date'}'),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No upcoming appointments found.'));
          }
        },
      ),
    );
  }
}