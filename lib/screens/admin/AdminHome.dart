import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin's Home"),
        centerTitle: true,
      ),
      body: Center(
        child: const Text(
          "Welcome to Admin's Dashboard",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
