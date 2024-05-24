import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transport_system/constants.dart';
import 'driver_home.dart';
import 'update_alerts.dart';
import 'view_route.dart';
import 'driver_profile.dart';

class ViewTimeLocation extends StatefulWidget {
  @override
  _ViewTimeLocationState createState() => _ViewTimeLocationState();
}

class _ViewTimeLocationState extends State<ViewTimeLocation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 3;
  String searchQuery = '';
  List<DocumentSnapshot> timeSchedules = [];

  @override
  void initState() {
    super.initState();
    fetchTimeSchedules();
  }

  Future<void> fetchTimeSchedules() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('time_schedules').get();
      setState(() {
        timeSchedules = snapshot.docs;
      });
      print('Fetched ${timeSchedules.length} time schedules');
    } catch (e) {
      print('Error fetching time schedules: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UpdateAlerts()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewRoute()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewTimeLocation()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> filteredTimeSchedules =
        timeSchedules.where((timeSchedule) {
      return timeSchedule['bus_number']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          timeSchedule['bus_route_number']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          timeSchedule['time']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: kMoonStones,
      appBar: AppBar(
        title: Text('View Time Schedule'),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search Time Schedules',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredTimeSchedules.isEmpty
                ? Center(child: Text('No time schedules found'))
                : ListView.builder(
                    itemCount: filteredTimeSchedules.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot timeSchedule =
                          filteredTimeSchedules[index];
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: ListTile(
                          leading: Icon(Icons.access_time, color: Colors.blue),
                          title: Text('Time: ${timeSchedule['time']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bus Number: ${timeSchedule['bus_number']}'),
                              Text(
                                  'Route Number: ${timeSchedule['bus_route_number']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Update Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: 'View Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'View Time Schedule',
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
