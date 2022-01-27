import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  bool isMe;
  MessageBubble(this.message, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        width:
            140, //width will not work if we have only container as parent widget
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }
}
