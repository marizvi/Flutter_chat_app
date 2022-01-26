import 'package:chat_app/widget/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreeen extends StatefulWidget {
  @override
  _AuthScreeenState createState() => _AuthScreeenState();
}

class _AuthScreeenState extends State<AuthScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(),
    );
  }
}
