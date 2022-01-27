import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
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
              final chatDocs = chatSnapshots.data?.docs ?? [];
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['userId'] == futuresnapshot.data!.uid,
                    chatDocs[index]['username']),
              );
              // return Text('hello');
            },
          );
        });
  }
}
