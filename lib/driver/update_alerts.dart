import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transport_system/constants.dart';
import 'driver_home.dart';
import 'view_route.dart';
import 'view_time_location.dart';
import 'driver_profile.dart';

class UpdateAlerts extends StatefulWidget {
  @override
  _UpdateAlertsState createState() => _UpdateAlertsState();
}

class _UpdateAlertsState extends State<UpdateAlerts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _alertController = TextEditingController();
  int _selectedIndex = 1;

  Future<String> _getname() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        String name = data?['name'] ?? '';
        return name;
      }
    }
    return '';
  }

  void _addAlert() async {
    if (_alertController.text.isNotEmpty) {
      await _firestore.collection('alerts').add({
        'alert': _alertController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _alertController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alert added successfully!')),
      );
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
    return Scaffold(
      backgroundColor: kMoonStones,
      appBar: AppBar(
        title: Text('Update Alerts'),
      ),
      body: FutureBuilder<String>(
        future: _getname(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String name = snapshot.data ?? 'User';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Hello, $name! Update your alerts here.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 28.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _alertController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.notification_important),
                      labelText: 'Enter alert message',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addAlert,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 24.0),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Add Alert',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('alerts')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var alerts = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: alerts.length,
                          itemBuilder: (context, index) {
                            var alert = alerts[index];
                            return Card(
                              margin: EdgeInsets.all(10.0),
                              child: ListTile(
                                leading: Icon(Icons.notification_important,
                                    color: Colors.red),
                                title: Text(alert['alert']),
                                subtitle: Text(
                                  (alert['timestamp'] as Timestamp)
                                      .toDate()
                                      .toString(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
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
