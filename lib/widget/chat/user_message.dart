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
  Future<String> getChatroomId() async {
    final user = await FirebaseAuth.instance.currentUser;
    // List<String> ids = [user!.uid, widget.oppositeid];
    // ids.sort();
    // String chatroomid = ids[0] + ids[1];
    // return chatroomid;
    String chatRoom;
    String str1 = myid;
    String str2 = userid;
    // <0 if str1<str2
    // >0 if str1>str2
    if (str1.compareTo(str2) == -1) {
      chatRoom = str1 + str2;
    } else {
      chatRoom = str2 + str1;
    }
    return chatRoom;
  }

  String? chatRoomId;

  Future<void> _getResponse() async {
    chatRoomId = await getChatroomId();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        //future builder is just for aligning my text towards right
        future: _getResponse(),
        // future: Future.value(FirebaseAuth.instance.currentUser),
        // builder: (context, AsyncSnapshot<User?> futuresnapshot) {
        builder: (context, futuresnapshot) {
          if (futuresnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatRoom')
                .doc(chatRoomId)
                .collection('chats')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshots) {
              if (chatSnapshots.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              // print(chatSnapshots.data?.docs[1].data());
              // final chatDocs = chatSnapshots.data?.docs ?? [];
              List<dynamic> chatDocs1 = chatSnapshots.data?.docs
                  .map((e) => e.data())
                  .toList() as List<dynamic>;

              // final allmsgs = chatDocs1.where((element) {
              //   if (element['myid'] == myid || element['oppositeid'] == myid) {
              //     return true;
              //   }
              //   return false;
              // }).toList();
              // print(userid);
              // print(myid);
              // print(allmsgs);
              // final chatDocs = allmsgs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs1.length,
                itemBuilder: (ctx, index) => MessageBubble(
                    chatDocs1[index]['text'],
                    chatDocs1[index]['userImage'],
                    chatDocs1[index]['userId'] == myid,
                    chatDocs1[index]['username']),
              );
              // return Text('hello');
            },
          );
        });
  }
}
