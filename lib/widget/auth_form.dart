import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 15,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null; //means everything is alright
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  validator: (value) {
                    //according to firebase password shQud be at least of 7 characters
                    if (value!.isEmpty || value.length < 8) {
                      return 'Password must be atleast seven characters';
                    }
                    return null; //means everything is alright
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true, //hide input text entered by user
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('Create new Account'))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
