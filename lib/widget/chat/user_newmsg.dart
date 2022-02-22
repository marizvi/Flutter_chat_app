import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserNewMsg extends StatefulWidget {
  final String oppositeid;
  UserNewMsg(this.oppositeid);
  @override
  State<UserNewMsg> createState() => _NewMessageState();
}

class _NewMessageState extends State<UserNewMsg> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus(); //to close the keyboard
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      //we creating this below field extra to maintain proper order
      'createdAt': Timestamp.now(), //cloud_firestore package
      'userId': user.uid,
      'myid': user.uid,
      'oppositeid': widget.oppositeid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              //Defaults to an uppercase keyboard for the first letter of each sentence.
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message..'),
              onChanged: (value) {
                setState(() {
                  //will update entered message with every keystroke
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
