import 'dart:convert';
import 'package:chat_app/widget/chat/messages.dart';
import 'package:chat_app/widget/chat/new_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Chatscreen extends StatefulWidget {
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  //..................
  //flutter_local notification
  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();
  //...................

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    //https://firebase.flutter.dev/docs/messaging/usage/
    FirebaseMessaging.instance
        .requestPermission(); //this line is necessary for foreground
    //for background go to main.dart file

    //...................................
    //for local notification
    //watch: https://www.youtube.com/watch?v=U38FJ40cEAE
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var IOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: IOSinitilize);
    fltrNotification.initialize(initilizationsSettings);
    //.....................................

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');
      if (message.notification != null) {
        _showNotification(
            message.notification!.title, message.notification!.body);
        print(
            'Message contained a notification: ${message.notification!.title} and ${message.notification!.body}');
      }
    });
  }

//..............................
//for flutter local notification
  Future<void> _showNotification(String? title, String? body) async {
    var androidDetails = new AndroidNotificationDetails(
        'Channel Id', 'Channel title',
        channelDescription: 'Description', importance: Importance.high);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);
    await fltrNotification.show(
        0, '$title', '$body', generalNotificationDetails);
  }
//.............................

  @override
  Widget build(BuildContext context) {
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
              child: Messages(),
            ),
            NewMessage(),
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
