import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String img_url;
  final String name;
  final String id;
  UserWidget(this.img_url, this.name, this.id);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        child: ListTile(
          onTap: () {
            print('hello');
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(img_url),
          ),
          title: Text(name),
          subtitle: Text(id),
        ),
      ),
    );
  }
}
