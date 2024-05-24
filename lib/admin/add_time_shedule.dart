import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transport_system/admin/add_bus_location.dart';
import 'package:transport_system/admin/gen_report.dart';
import 'package:transport_system/admin/admin_home.dart';

class AddTimeSchedule extends StatefulWidget {
  @override
  _AddTimeScheduleState createState() => _AddTimeScheduleState();
}

class _AddTimeScheduleState extends State<AddTimeSchedule> {
  final TextEditingController _timeController = TextEditingController();
  int _selectedIndex = 2;
  String? _selectedBusNumber;
  String? _selectedBusRouteNumber;
  List<String> _busNumbers = [];
  List<String> _busRouteNumbers = [];

  @override
  void initState() {
    super.initState();
    _fetchBusNumbersAndRoutes();
  }

  Future<void> _fetchBusNumbersAndRoutes() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('bus_locations').get();
    setState(() {
      _busNumbers =
          snapshot.docs.map((doc) => doc['bus_number'].toString()).toList();
      _busRouteNumbers = snapshot.docs
          .map((doc) => doc['bus_route_number'].toString())
          .toList();
    });
  }

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
          MaterialPageRoute(builder: (context) => GenerateReport()),
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
              'Add Time Schedule',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 28.0,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedBusNumber,
              onChanged: (newValue) {
                setState(() {
                  _selectedBusNumber = newValue;
                });
              },
              items: _busNumbers.map((busNumber) {
                return DropdownMenuItem<String>(
                  value: busNumber,
                  child: Text(busNumber),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Bus Number',
                prefixIcon: Icon(Icons.directions_bus),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedBusRouteNumber,
              onChanged: (newValue) {
                setState(() {
                  _selectedBusRouteNumber = newValue;
                });
              },
              items: _busRouteNumbers.map((busRouteNumber) {
                return DropdownMenuItem<String>(
                  value: busRouteNumber,
                  child: Text(busRouteNumber),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Bus Route Number',
                prefixIcon: Icon(Icons.confirmation_number),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.access_time),
                labelText: 'Time',
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
                      .collection('time_schedules')
                      .add({
                    'bus_number': _selectedBusNumber,
                    'bus_route_number': _selectedBusRouteNumber,
                    'time': _timeController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Time schedule added successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add time schedule: $e')),
                  );
                  print('Error adding time schedule to Firestore: $e');
                }
              },
              child: Text(
                'Add Schedule',
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
