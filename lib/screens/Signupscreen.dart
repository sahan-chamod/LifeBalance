import 'package:flutter/material.dart';
import '../firebase/signup_helper.dart';
import '../utils/app_colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _dobController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileNumberController.dispose();
    _dobController.dispose();
    super.dispose();
  }

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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField('Full Name', 'Enter your full name', _fullNameController),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildInputField('Email', 'example@example.com', _emailController),
              const SizedBox(height: 16),
              _buildInputField('Mobile Number', '123-456-7890', _mobileNumberController),
              const SizedBox(height: 16),
              _buildInputField('Date of Birth', 'DD / MM / YYYY', _dobController),
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
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
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
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            filled: true,
            fillColor: AppColors.inputBackground,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
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
          ),
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          TextSpan(
            text: ' and ',
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(fontSize: 16, color: AppColors.buttonTextColor),
      ),
    );
  }

  Widget _buildSocialSignUp() {
    return Column(
      children: [
        const Text('or sign up with'),
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
          const TextSpan(text: 'Already have an account? '),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Log in',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _firebaseHelper.createUser(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          mobileNumber: _mobileNumberController.text,
          dateOfBirth: _dobController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
