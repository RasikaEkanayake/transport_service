import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Report'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(document['report_title']),
                subtitle: Text(document['report_description']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
