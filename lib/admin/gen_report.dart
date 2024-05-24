import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:transport_system/admin/add_bus_location.dart';
import 'package:transport_system/admin/add_time_shedule.dart';
import 'package:transport_system/admin/admin_home.dart';

class GenerateReport extends StatefulWidget {
  @override
  _GenerateReportState createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  int _selectedIndex = 3;

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
      case 4:
        // Handle Profile navigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Generate Reports',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  generateReport(context, 'users', 'Users List Report');
                },
                child: Text(
                  'Users List Report',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  generateReport(
                      context, 'seat_reservations', 'Seat Reservation Report');
                },
                child: Text(
                  'Seat Reservation Report',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  generateReport(
                      context, 'time_schedules', 'Time Schedules Report');
                },
                child: Text(
                  'Time Schedules Report',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  generateReport(
                      context, 'bus_locations', 'Bus Locations Report');
                },
                child: Text(
                  'Bus Locations Report',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
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

  void generateReport(
      BuildContext context, String collection, String reportTitle) async {
    final pdf = pw.Document();

    final querySnapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();

    if (data.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  reportTitle,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>[...data.first.keys], // Headers
                    ...data.map((row) =>
                        row.values.map((value) => value.toString()).toList()),
                  ],
                ),
              ],
            );
          },
        ),
      );

      Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } else {
      // Show a message if there is no data
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Data'),
            content: Text(
                'There is no data available in the $collection collection.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
