import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userid;
  bool isMe;
  MessageBubble(this.message, this.isMe, this.userid);

  @override
  Widget build(BuildContext context) {
    return Row(
      //to make width of container work
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.pink[300] : Colors.grey[300],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)),
            ),
            width:
                180, //width will not work if we have only container as parent widget
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Text(
                  userid,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
