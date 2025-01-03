import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import 'PaymentSuccessScreen.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Payment', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '\$100.00',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/doctor.jpg'), // Add image to assets folder
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Olivia Turner, M.D.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Dermato-Endocrinology',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(' 5 ', style: TextStyle(fontSize: 14)),
                        Icon(Icons.person, color: Colors.grey, size: 16),
                        Text(' 60', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            _buildDetailRow('Date / Hour', 'Month 24, Year / 10:00 AM'),
            _buildDetailRow('Duration', '30 Minutes'),
            _buildDetailRow('Booking for', 'Another Person'),
            SizedBox(height: 10),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            _buildDetailRow('Amount', '\$100.00'),
            _buildDetailRow('Duration', '30 Minutes'),
            _buildDetailRow('Total', '\$100'),
            _buildDetailRow('Payment Method', 'Card'),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
              ),
              onPressed: () {
                // Navigate to PaymentSuccessScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen()),
                );
              },
              child: Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
