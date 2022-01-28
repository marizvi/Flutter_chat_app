import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
        ),
        TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.camera),
            label: Text('Add Image')),
      ],
    );
  }
}
