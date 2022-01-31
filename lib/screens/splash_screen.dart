import 'package:flutter/material.dart';

//when firebase verifies a token on opening an app
//it takes few miliseconds due to which we see a glitch
//of loginscreen before chatscreen could appear
//this is why we are using this
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
