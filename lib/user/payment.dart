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
  final TextEditingController _nameOnCardController = TextEditingController();
  bool _isProcessing = false;

  Future<void> confirmPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate network delay for payment processing
    await Future.delayed(Duration(seconds: 3));

    // Update reserved seats in the 'reserved_seats' collection
    await _firestore
        .collection('reserved_seats')
        .doc('${widget.busNumber}-${widget.time}')
        .set({
      'seats': FieldValue.arrayUnion(widget.selectedSeats),
    }, SetOptions(merge: true));

    // Save payment information to the 'payments' collection
    await _firestore.collection('payments').add({
      'user_name': widget.userName,
      'payment_amount': widget.totalCost,
      'bus_number': widget.busNumber,
      'time': widget.time,
      'seats': widget.selectedSeats,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isProcessing = false;
    });

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Total Cost: ${widget.totalCost} LKR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameOnCardController,
              decoration: InputDecoration(
                labelText: 'Name on Card',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            _isProcessing
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: confirmPayment,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment),
                        SizedBox(width: 10),
                        Text(
                          'Submit Payment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 24.0),
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
