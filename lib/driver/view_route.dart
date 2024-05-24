import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver_home.dart';
import 'update_alerts.dart';
import 'view_time_location.dart';
import 'driver_profile.dart';

class ViewRoute extends StatefulWidget {
  @override
  _ViewRouteState createState() => _ViewRouteState();
}

class _ViewRouteState extends State<ViewRoute> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 2;
  String searchQuery = '';
  List<DocumentSnapshot> busRoutes = [];

  @override
  void initState() {
    super.initState();
    fetchBusRoutes();
  }

  Future<void> fetchBusRoutes() async {
    QuerySnapshot snapshot = await _firestore.collection('bus_locations').get();
    setState(() {
      busRoutes = snapshot.docs;
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
    List<DocumentSnapshot> filteredRoutes = busRoutes.where((route) {
      return route['bus_number']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          route['bus_route_number']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          route['bus_start_location']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          route['bus_end_location']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            'View Routes',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w700,
              fontSize: 28.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search Routes',
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
            child: ListView.builder(
              itemCount: filteredRoutes.length,
              itemBuilder: (context, index) {
                DocumentSnapshot route = filteredRoutes[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: Icon(Icons.directions_bus, color: Colors.blue),
                    title: Text('Bus Number: ${route['bus_number']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Route Number: ${route['bus_route_number']}'),
                        Text('Start Location: ${route['bus_start_location']}'),
                        Text('End Location: ${route['bus_end_location']}'),
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
