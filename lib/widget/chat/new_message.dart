import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();
  void _sendMessage() {
    FocusScope.of(context).unfocus(); //to close the keyboard
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      //we creating this below field extra to maintain proper order
      'createdAt': Timestamp.now(), //cloud_firestore package
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
