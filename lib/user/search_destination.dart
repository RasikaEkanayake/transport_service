import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transport_system/user/user_home.dart';
import 'package:transport_system/user/seat_reserve.dart';
import 'package:transport_system/user/view_alerts.dart';
import 'package:transport_system/user/view_route.dart';
import 'package:transport_system/user/view_time_location.dart';

class SearchDestination extends StatefulWidget {
  @override
  _SearchDestinationState createState() => _SearchDestinationState();
}

class _SearchDestinationState extends State<SearchDestination> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 1;
  String searchQuery = '';
  List<DocumentSnapshot> busLocations = [];

  @override
  void initState() {
    super.initState();
    fetchBusLocations();
  }

  Future<void> fetchBusLocations() async {
    QuerySnapshot snapshot = await _firestore.collection('bus_locations').get();
    setState(() {
      busLocations = snapshot.docs;
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
          MaterialPageRoute(builder: (context) => UserHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchDestination()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeatReserve()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewAlerts()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewRoute()),
        );
        break;
      case 5:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewTimeLocation()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> filteredLocations = busLocations.where((location) {
      return location['bus_end_location']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            'Search by Destination',
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
                labelText: 'Search by Destination',
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
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                DocumentSnapshot location = filteredLocations[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: Icon(Icons.directions_bus, color: Colors.blue),
                    title: Text('Bus Number: ${location['bus_number']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Route Number: ${location['bus_route_number']}'),
                        Text(
                            'Start Location: ${location['bus_start_location']}'),
                        Text('End Location: ${location['bus_end_location']}'),
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
            icon: Icon(Icons.search),
            label: 'Search by Destination',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat),
            label: 'Seat Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'View Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'View Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'View Time Schedule',
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
