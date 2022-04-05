import 'package:chat_app/widget/user_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  //..................
  //flutter_local notification
  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();
  //...................

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

    //Below part is only to show pop notification recieved from firebase
    // in notification bar while running an app
    // through FLutter local notificaiton
    // otherwise firebase part has nothing to do with this
    // actual code, both background and terminated background
    // is handled through .xml and gradle file only

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

  var _users = [];
  var _id = [];
  String? myid;
  Future<void> _fetchUsers() async {
    print('inside fetch users');
    QuerySnapshot querySnapshot_data =
        await FirebaseFirestore.instance.collection('users').get();
    // print(querySnapshot_data.docs.length);
    _users = querySnapshot_data.docs.map((e) => e.data()).toList();
    QuerySnapshot querySnapshot_id =
        await FirebaseFirestore.instance.collection('users').get();
    _id = querySnapshot_id.docs.map((e) => e.id).toList();
    myid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    // print(_id);
    // print(_users);
    // print(myid);
    return Scaffold(
        appBar: AppBar(
          title: Text('Users..'),
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
        body: FutureBuilder(
            future: _fetchUsers(),
            builder: (ctx, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                return ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) => _id[index] != myid
                      ? UserWidget(
                          _users[index]['image_url'],
                          _users[index]['username'],
                          _id[index],
                          myid.toString())
                      : Center(),
                );
              }
            }));
  }
}
