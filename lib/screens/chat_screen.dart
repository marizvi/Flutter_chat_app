import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chatscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //streambuilder revaluates the builder whenever our stream gets changed
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/73zO0c4wyXnTNPREyxgA/messages')
            .snapshots(includeMetadataChanges: true),
        //AsyncSnapshot<QuerySnapshot> is necessary before streamsnapshots
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshots) {
          if (streamSnapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: streamSnapshots.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.all(8),
                  child: Text(streamSnapshots.data!.docs[index]['text'])));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //for this remember to initialize firebase app in main.dart
          FirebaseFirestore.instance
              .collection('chats/73zO0c4wyXnTNPREyxgA/messages')
              .snapshots()
              .listen((data) {
            print(data.docs);
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
