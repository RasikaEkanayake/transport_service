import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transport_system/admin/add_time_shedule.dart';
import 'package:transport_system/admin/admin_profile.dart';
import 'package:transport_system/admin/gen_report.dart';
import 'package:transport_system/admin/admin_home.dart';

class AddBusLocation extends StatefulWidget {
  @override
  _AddBusLocationState createState() => _AddBusLocationState();
}

class _AddBusLocationState extends State<AddBusLocation> {
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _busRouteNumberController =
      TextEditingController();
  final TextEditingController _busStartLocationController =
      TextEditingController();
  final TextEditingController _busEndLocationController =
      TextEditingController();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddBusLocation()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddTimeSchedule()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Add Bus Location',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 28.0,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _busNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.directions_bus),
                labelText: 'Bus Number',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _busRouteNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.confirmation_number),
                labelText: 'Bus Route Number',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _busStartLocationController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                labelText: 'Bus Start Location',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _busEndLocationController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_off),
                labelText: 'Bus End Location',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('bus_locations')
                      .add({
                    'bus_number': _busNumberController.text,
                    'bus_route_number': _busRouteNumberController.text,
                    'bus_start_location': _busStartLocationController.text,
                    'bus_end_location': _busEndLocationController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bus location added successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add bus location: $e')),
                  );
                  print('Error adding bus location to Firestore: $e');
                }
              },
              child: Text(
                'Add Bus Location',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Add Bus Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Time Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
