import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpcomingAppointmentsPage extends StatelessWidget {
  const UpcomingAppointmentsPage({Key? key}) : super(key: key);

  Stream<QuerySnapshot> fetchUpcomingBookings() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('appointments')
        .where('appointmentDate',
            isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
        .orderBy('appointmentDate', descending: false)
        .snapshots();
  }

  Future<String> fetchDoctorName(String doctorNameField) async {
    final firestore = FirebaseFirestore.instance;
    final appointmentsSnapshot =
        await firestore.collection('appointments').get();

    for (final doc in appointmentsSnapshot.docs) {
      if (doc.data().containsKey('name')) {
        return doc['name'] ?? 'Unknown Doctor';
      }
    }
    return 'Unknown Doctor';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchUpcomingBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No upcoming bookings found.'));
        }

        final bookings = snapshot.data!.docs;

        return FutureBuilder<String>(
          future: fetchDoctorName(bookings[0]['doctorId']),
          builder: (context, doctorSnapshot) {
            if (doctorSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (doctorSnapshot.hasError) {
              return const Center(child: Text('Error fetching doctor name.'));
            }

            final doctorName = doctorSnapshot.data ?? 'Unknown Doctor';

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final appointmentDate =
                    DateTime.parse(booking['appointmentDate']);
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Doctor: $doctorName'),
                    subtitle: Text('Date: ${appointmentDate.toLocal()}'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
