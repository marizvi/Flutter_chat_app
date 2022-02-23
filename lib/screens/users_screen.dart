import 'package:chat_app/widget/user_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
