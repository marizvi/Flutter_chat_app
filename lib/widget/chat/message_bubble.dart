import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userImage;
  bool isMe;
  MessageBubble(this.message, this.userImage, this.isMe, this.username);

  @override
  Widget build(BuildContext context) {
    return Stack(
      //Stack is only for user image on every message
      children: [
        Row(
          //to make width of container work
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.pink[300] : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft:
                          !isMe ? Radius.circular(0) : Radius.circular(12),
                      bottomRight:
                          isMe ? Radius.circular(0) : Radius.circular(12)),
                ),
                width:
                    168, //width will not work if we have only container as parent widget
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                  ],
                )),
          ],
        ),
        Positioned(
          //positioned widget helps us to position a
          //widget in a stack
          top: -7,
          left: isMe ? null : 140,
          right: isMe ? 140 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
      //for visible overflow in stack
      clipBehavior: Clip.none,
    );
  }
}
