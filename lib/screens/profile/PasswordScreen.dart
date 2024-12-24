import 'package:flutter/material.dart';
import 'package:life_balance/firebase/user_helper.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _currentPassword=TextEditingController();
  final TextEditingController _newPassword=TextEditingController();
  final TextEditingController _confirmPassword=TextEditingController();

  checkForms(){
    if(_currentPassword.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Old Password Required",style: TextStyle(
              fontSize:20.0
          ),),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
      return "";
    }

    if(_newPassword.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New Password Required",style: TextStyle(
              fontSize:20.0
          ),),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
      return "";
    }

    if(_newPassword.text!=_confirmPassword.text){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New Password and Confirm passwords should be matched",style: TextStyle(
              fontSize:20.0
          ),),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
      return "";
    }
      updatePassword(_currentPassword.text, _newPassword.text,context,clearTheForms);
  }

  clearTheForms(){
    _currentPassword.text="";
    _newPassword.text="";
    _confirmPassword.text="";
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Password Manager",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    _passwordField("Current Password", _currentPassword),
                    const SizedBox(height: 20),
                    _passwordField("New Password", _newPassword),
                    const SizedBox(height: 20),
                    _passwordField("Confirm New Password", _confirmPassword),
                    const SizedBox(height:40),
                    Row(
                      children: [
                        Expanded( child:ElevatedButton(
                         onPressed: () {
                           checkForms();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),

                          ),
                          child: const Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ))
                      ],
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

Widget _passwordField(
    String label,
    TextEditingController controller, {
      bool obscureText = true,
    }) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

