import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor's Home"),
        centerTitle: true,
      ),
      body: Center(
        child: const Text(
          "Welcome to Doctor's Dashboard",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
