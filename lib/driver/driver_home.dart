import 'package:flutter/material.dart';

class DriverHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Home'),
      ),
      body: Center(
        child: Text('Welcome, Guest!'),
      ),
    );
  }
}
