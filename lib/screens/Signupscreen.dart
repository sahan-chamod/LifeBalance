import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Account',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField('Full name', 'Enter your full name'),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildInputField('Email', 'example@example.com'),
            const SizedBox(height: 16),
            _buildInputField('Mobile Number', '123-456-7890'),
            const SizedBox(height: 16),
            _buildInputField('Date Of Birth', 'DD / MM / YYYY'),
            const SizedBox(height: 24),
            _buildTermsAndConditions(),
            const SizedBox(height: 16),
            _buildSignUpButton(),
            const SizedBox(height: 16),
            _buildSocialSignUp(),
            const SizedBox(height: 16),
            _buildLoginPrompt(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 10, 10, 10),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.primaryColor),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: Color.fromARGB(255, 17, 17, 17),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(color: AppColors.primaryColor),
            filled: true,
            fillColor: AppColors.inputBackground,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'By continuing, you agree to ',
            style: TextStyle(fontSize: 12, color: AppColors.textColor),
          ),
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
          ),
          TextSpan(
            text: ' and ',
            style: TextStyle(fontSize: 12, color: AppColors.textColor),
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(color: AppColors.buttonTextColor, fontSize: 16),
      ),
    );
  }

  Widget _buildSocialSignUp() {
    return Column(
      children: [
        const Text(
          'or sign up with',
          style: TextStyle(fontSize: 12, color: AppColors.textColor),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Icons.g_mobiledata),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.facebook),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.fingerprint),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.buttonIconColor,
      child: Icon(icon, color: AppColors.primaryColor),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(fontSize: 12, color: AppColors.textColor),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Log in',
                style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
