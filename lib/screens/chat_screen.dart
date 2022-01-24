import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chatscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text('this works!'),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //for this remember to initialize firebase app in main.dart
          FirebaseFirestore.instance
              .collection('chats/73zO0c4wyXnTNPREyxgA/messages')
              .snapshots()
              .listen((data) {
            // print(data.docs[0]['text']);
            data.docs.forEach((element) {
              print(element['text']);
            });
          });
          //snapshots returns a Stream means it is going
          // to emit new values whenever data changes
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
