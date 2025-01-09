import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpcomingAppointmentsPage extends StatelessWidget {
  const UpcomingAppointmentsPage({Key? key}) : super(key: key);

  Stream<QuerySnapshot> fetchUpcomingBookings() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('appointments')
        .where(
          'appointmentDate',
          isGreaterThanOrEqualTo: DateTime.now().toIso8601String(),
        )
        .orderBy('appointmentDate')
        .snapshots();
  }

  Future<String> fetchDoctorName(String doctorId) async {
    try {
      final doctorSnapshot =
          await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();
      return doctorSnapshot.data()?['name'] ?? 'Unknown Doctor';
    } catch (e) {
      return 'Unknown Doctor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchUpcomingBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No upcoming bookings found.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final appointmentDate =
                  DateTime.parse(booking['appointmentDate']);
              final doctorId = booking['doctorId'];

              return FutureBuilder<String>(
                future: fetchDoctorName(doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading doctor name...'),
                      subtitle: Text('Fetching details...'),
                    );
                  }

                  final doctorName = doctorSnapshot.data ?? 'Unknown Doctor';

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Doctor: $doctorName'),
                      subtitle: Text(
                          'Date: ${appointmentDate.toLocal().toString().split(' ')[0]}'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
