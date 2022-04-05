import 'dart:convert';
import 'package:chat_app/widget/chat/messages.dart';
import 'package:chat_app/widget/chat/new_message.dart';
import 'package:chat_app/widget/chat/user_message.dart';
import 'package:chat_app/widget/chat/user_newmsg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserChatscreen extends StatefulWidget {
  @override
  State<UserChatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<UserChatscreen> {
  void _selectPage() {
    Navigator.of(context).pushNamed('/user_screen');
  }

  @override
  Widget build(BuildContext context) {
    final route =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final userid = route['userid'];
    final myid = route['myid'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            underline: Container(), //to remove light bottom line
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
              child: UserMessages(userid.toString(), myid.toString()),
            ),
            UserNewMsg(userid.toString()),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/73zO0c4wyXnTNPREyxgA/messages')
      //         .add({'text': 'This is the hard coded text'});
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
