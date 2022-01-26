import 'dart:convert';
import 'package:chat_app/widget/chat/messages.dart';
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
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
          ],
        ),
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
