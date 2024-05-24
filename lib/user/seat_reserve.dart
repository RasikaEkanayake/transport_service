import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transport_system/user/payment.dart';
import 'package:transport_system/user/user_home.dart';
import 'package:transport_system/user/search_destination.dart';
import 'package:transport_system/user/view_alerts.dart';
import 'package:transport_system/user/view_route.dart';
import 'package:transport_system/user/view_time_location.dart';

class SeatReserve extends StatefulWidget {
  @override
  _SeatReserveState createState() => _SeatReserveState();
}

class _SeatReserveState extends State<SeatReserve> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 2;
  String? selectedBusNumber;
  String? selectedTime;
  List<String> busNumbers = [];
  List<String> busTimes = [];
  List<String> reservedSeats = [];
  List<String> selectedSeats = [];
  final int seatCost = 1500;
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchBusNumbers();
    fetchUserName();
  }

  Future<void> fetchBusNumbers() async {
    QuerySnapshot snapshot = await _firestore.collection('bus_locations').get();
    setState(() {
      busNumbers =
          snapshot.docs.map((doc) => doc['bus_number'].toString()).toList();
    });
  }

  Future<void> fetchBusTimes() async {
    if (selectedBusNumber != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('time_schedules')
          .where('bus_number', isEqualTo: selectedBusNumber)
          .get();
      setState(() {
        busTimes = snapshot.docs.map((doc) => doc['time'].toString()).toList();
      });
    }
  }

  Future<void> fetchReservedSeats() async {
    if (selectedBusNumber != null && selectedTime != null) {
      DocumentSnapshot doc = await _firestore
          .collection('reserved_seats')
          .doc('$selectedBusNumber-$selectedTime')
          .get();
      if (doc.exists) {
        setState(() {
          reservedSeats = List<String>.from(doc['seats']);
        });
      } else {
        setState(() {
          reservedSeats = [];
        });
      }
    }
  }

  Future<void> fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
        });
      }
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

  Widget buildSeat(String seatNumber) {
    bool isReserved = reservedSeats.contains(seatNumber);
    bool isSelected = selectedSeats.contains(seatNumber);
    Color seatColor = isReserved
        ? Colors.grey
        : isSelected
            ? Colors.green
            : Colors.blue;
    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            if (isSelected) {
              selectedSeats.remove(seatNumber);
            } else {
              selectedSeats.add(seatNumber);
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  void proceedToPayment() {
    int totalCost = selectedSeats.length * seatCost;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          busNumber: selectedBusNumber!,
          time: selectedTime!,
          selectedSeats: selectedSeats,
          totalCost: totalCost,
          userName: userName!,
        ),
      ),
    ).then((paymentSuccess) {
      if (paymentSuccess == true) {
        setState(() {
          reservedSeats.addAll(selectedSeats);
          selectedSeats.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed. Please try again.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> seatNumbers = [];
    for (int row = 1; row <= 11; row++) {
      seatNumbers.addAll(
          ['${row}A', '${row}B', '  ', '${row}C', '${row}D', '${row}E']);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Seat Reservation',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 28.0,
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.directions_bus),
                labelText: 'Select Bus Number',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              value: selectedBusNumber,
              items: busNumbers.map((busNumber) {
                return DropdownMenuItem(
                  value: busNumber,
                  child: Text(busNumber),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBusNumber = value;
                  selectedTime =
                      null; // Reset selected time when bus number changes
                  busTimes.clear(); // Clear bus times when bus number changes
                  fetchBusTimes();
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.access_time),
                labelText: 'Select Time',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              value: selectedTime,
              items: busTimes.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                  fetchReservedSeats();
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: seatNumbers.length,
                itemBuilder: (context, index) {
                  return seatNumbers[index] == '  '
                      ? Container()
                      : buildSeat(seatNumbers[index]);
                },
              ),
            ),
            ElevatedButton(
              onPressed: selectedSeats.isEmpty ? null : proceedToPayment,
              child: Text(
                'Proceed to Payment',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                backgroundColor:
                    selectedSeats.isEmpty ? Colors.grey : Colors.blue,
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
