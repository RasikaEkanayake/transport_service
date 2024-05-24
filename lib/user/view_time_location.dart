import 'package:flutter/material.dart';

class ViewTimeLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Time Schedule'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'View Time Schedule Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
