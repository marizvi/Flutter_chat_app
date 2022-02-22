import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class UserMessages extends StatelessWidget {
  final String userid;
  final String myid;
  UserMessages(this.userid, this.myid);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future builder is just for aligning my text towards right
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, AsyncSnapshot<User?> futuresnapshot) {
          if (futuresnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshots) {
              if (chatSnapshots.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              // print(chatSnapshots.data?.docs[0].data());
              // final chatDocs = chatSnapshots.data?.docs ?? [];
              List<dynamic> chatDocs1 = chatSnapshots.data?.docs
                  .map((e) => e.data())
                  .toList() as List<dynamic>;
              final allmsgs = chatDocs1.where((element) {
                if (element['myid'] == myid || element['oppositeid'] == myid) {
                  return true;
                }
                return false;
              }).toList();
              print(userid);
              print(myid);
              print(allmsgs);
              // final chatDocs = allmsgs;
              return ListView.builder(
                reverse: true,
                itemCount: allmsgs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                    allmsgs[index]['text'],
                    allmsgs[index]['userImage'],
                    allmsgs[index]['userId'] == futuresnapshot.data!.uid,
                    allmsgs[index]['username']),
              );
              // return Text('hello');
            },
          );
        });
  }
}
