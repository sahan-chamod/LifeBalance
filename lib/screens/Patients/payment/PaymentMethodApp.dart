import 'package:flutter/material.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedOption = 'Card'; // Default selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pop(context); // Handle back action
          },
        ),
        title: Text(
          'Payment Method',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit & Debit Card',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10),
            _buildPaymentOption(
              icon: Icons.credit_card,
              label: 'Add New Card',
              value: 'Card',
              onTap: () {
                // Navigate to AddCardScreen
                Navigator.pushNamed(context, AppRoutes.addcards);
              },
            ),
            SizedBox(height: 20),
            Text(
              'More Payment Options',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10),
            _buildPaymentOption(
              icon: Icons.apple,
              label: 'Apple Pay',
              value: 'Apple',
            ),
            _buildPaymentOption(
              icon: Icons.payment,
              label: 'Paypal',
              value: 'Paypal',
            ),
            _buildPaymentOption(
              icon: Icons.play_circle_filled,
              label: 'Google Pay',
              value: 'Google',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap, // Optional callback for navigation
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
        size: 30,
      ),
      title: Text(
        label,
        style: TextStyle(color: AppColors.textColor),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedOption,
        onChanged: (String? newValue) {
          setState(() {
            _selectedOption = newValue!;
          });
          if (onTap != null) {
            onTap(); // Trigger navigation or additional action
          }
        },
        activeColor: AppColors.primaryColor,
      ),
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
        if (onTap != null) {
          onTap(); // Trigger the callback
        }
      },
    );
  }
}
