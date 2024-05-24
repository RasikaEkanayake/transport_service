import 'package:flutter/material.dart';

class ViewAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Alerts'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'View Alerts Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
