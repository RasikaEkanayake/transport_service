import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  final String busNumber;
  final String time;
  final List<String> selectedSeats;
  final int totalCost;
  final String userName;

  PaymentScreen({
    required this.busNumber,
    required this.time,
    required this.selectedSeats,
    required this.totalCost,
    required this.userName,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  Future<void> confirmPayment() async {
    // Simulate network delay for payment processing
    await Future.delayed(Duration(seconds: 3));
    // Simulate successful payment
    await _firestore
        .collection('reserved_seats')
        .doc('${widget.busNumber}-${widget.time}')
        .set({
      'seats': FieldValue.arrayUnion(widget.selectedSeats),
      'user_name': widget.userName,
      'payment_amount': widget.totalCost,
    }, SetOptions(merge: true));
    Navigator.of(context)
        .pop(true); // Return true to indicate successful payment
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Total Cost: ${widget.totalCost} LKR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YY)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cvvController,
              decoration: InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                confirmPayment();
              },
              child: Text(
                'Submit Payment',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
