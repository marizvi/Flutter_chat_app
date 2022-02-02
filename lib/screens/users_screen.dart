import 'package:chat_app/widget/user_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var _users = [];
  var _id = [];
  Future<void> _fetchUsers() async {
    print('inside fetch users');
    QuerySnapshot querySnapshot_data =
        await FirebaseFirestore.instance.collection('users').get();
    _users = querySnapshot_data.docs.map((e) => e.data()).toList();
    QuerySnapshot querySnapshot_id =
        await FirebaseFirestore.instance.collection('users').get();
    _id = querySnapshot_id.docs.map((e) => e.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    // print('users:');
    // print(_users);
    return Scaffold(
        appBar: AppBar(
          title: Text('Users..'),
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
                  itemBuilder: (context, index) => UserWidget(
                      _users[index]['image_url'],
                      _users[index]['username'],
                      _id[index]),
                );
              }
            }));
  }
}
