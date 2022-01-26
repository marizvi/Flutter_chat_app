import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            onChanged: (itemidentifier) {
              if (itemidentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
          )
        ],
      ),
      //streambuilder revaluates the builder whenever our stream gets changed
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/73zO0c4wyXnTNPREyxgA/messages')
            .snapshots(),
        //AsyncSnapshot<QuerySnapshot> is necessary before streamsnapshots
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshots) {
          if (streamSnapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final documents = streamSnapshots.data!.docs;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.all(8),
                  child: Text(documents[index]['text'])));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/73zO0c4wyXnTNPREyxgA/messages')
              .add({'text': 'This is the hard coded text'});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
