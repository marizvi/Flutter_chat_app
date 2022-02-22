import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String img_url;
  final String name;
  final String userid;
  final String myid;
  UserWidget(this.img_url, this.name, this.userid, this.myid);
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
            Navigator.of(context).pushNamed('/user_chatscreen',
                arguments: {'userid': userid, 'myid': myid});
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(img_url),
          ),
          title: Text(name),
          subtitle: Column(
            children: [
              Text("My id: $myid"),
              Text("User id $userid"),
            ],
          ),
        ),
      ),
    );
  }
}
