import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  bool? _isCamera;
  void _pickImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;
    pickedImage = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 300);
    //imageQuality varies from 0 to 100
    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.imagePickFn(File(_pickedImage!.path));
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;
    pickedImage = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 300);

    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.imagePickFn(File(_pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.camera),
            label: Text('Add Image')),
      ],
    );
  }
}
