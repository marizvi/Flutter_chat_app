import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLogin = true;
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';

  void _trySubmit() {
    FocusScope.of(context).unfocus(); //this will close the keyboard
    // .validate is a boolean type and will return true if all
    // validated fields return null
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      // .save() will trigger onSaved: for all textFormField
      _formKey.currentState!.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bb6.jpg'), fit: BoxFit.fill)),
      child: Center(
        child: Card(
          margin: EdgeInsets.all(12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 15,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                      // key is necessary when we are changing number of
                      // textform fields dynamically, to prvent swapping of values
                      // among these fields
                      key: ValueKey('userEmail'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null; //means everything is alright
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onSaved: (value) {
                        _userEmail = value;
                      }),
                  if (!_isLogin)
                    TextFormField(
                        // key is necessary when we are changing number of
                        // textform fields dynamically, to prvent swapping of values
                        // among these fields
                        key: ValueKey('userName'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null; //means everything is alright.
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        }),
                  TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        //according to firebase password shQud be at least of 7 characters
                        if (value!.isEmpty || value.length < 8) {
                          return 'Password must be atleast 8 characters';
                        }
                        return null; //means everything is alright.
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: _passwordController,
                      obscureText: true, //hide input text entered by user
                      onSaved: (value) {
                        _userPassword = value;
                      }),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('conifrmPassword'),
                      validator: (value) {
                        if (value != _passwordController) {
                          return "password does not matches";
                        }
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 90,
                    child: ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Register'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18))),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new Account'
                          : 'Already have an Account'))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
