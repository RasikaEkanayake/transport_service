import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Route'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('routes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(document['route_name']),
                subtitle: Text('From: ${document['start_point']} To: ${document['end_point']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
