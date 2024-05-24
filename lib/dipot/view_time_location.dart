import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTimeLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Time & Location'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('time_locations').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text('Location: ${document['location']}'),
                subtitle: Text('Time: ${document['time']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
