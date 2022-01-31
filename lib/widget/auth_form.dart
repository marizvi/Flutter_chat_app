import 'package:chat_app/widget/picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final Function(String? email, String? password, String? username,
      File? _userImage, bool isLogin, BuildContext ctx) submitForm;
  final bool _isLoading;
  AuthForm(this.submitForm, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLogin = true;
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  File? _userImage;
  void _pickedImage(File image) {
    _userImage = image;
  }

  AnimationController? controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 280));
    _slideAnimation = Tween(begin: Offset(0, -0.7), end: Offset(0, 0)).animate(
        //Offset(x,y)
        CurvedAnimation(
            parent: controller as Animation<double>,
            curve: Curves.easeInOutQuad));

    _opacityAnimation = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(
        parent: controller as Animation<double>, curve: Curves.easeInSine));
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus(); //this will close the keyboard
    // .validate is a boolean type and will return true if all
    // validated fields return null
    final isValid = _formKey.currentState!.validate();

    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      // .save() will trigger onSaved: for all textFormField
      _formKey.currentState!.save();
      //trim() is use to remove leading and trailing white spaces
      widget.submitForm(
        _userEmail!.trim(),
        _userPassword!.trim(),
        _userName!.trim(),
        _userImage,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLogin) {
      controller!.forward();
    } else {
      controller!.reverse();
    }

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bb6.jpg'), fit: BoxFit.fill)),
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 260),
          curve: Curves.easeInOutQuad,
          height: _isLogin ? 290 : 520,
          child: Card(
            margin: EdgeInsets.all(18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 15,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                        // key is necessary when we are changing number of
                        // textform fields dynamically, to prvent swapping of values
                        // among these fields
                        key: ValueKey('userEmail'),
                        //few keyboard settings are below (optional)
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
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
                      FadeTransition(
                        opacity: _opacityAnimation as Animation<double>,
                        child: TextFormField(
                            // key is necessary when we are changing number of
                            // textform fields dynamically, to prvent swapping of values
                            // among these fields
                            key: ValueKey('userName'),
                            autocorrect: true,
                            // Defaults to an uppercase keyboard for the first letter of each word.
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
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
                      ),
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
                      FadeTransition(
                          opacity: _opacityAnimation as Animation<double>,
                          child: TextFormField(
                            key: ValueKey('conifrmPassword'),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return "password does not matches";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration:
                                InputDecoration(labelText: 'Confirm Password'),
                          )),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget._isLoading) CircularProgressIndicator(),
                    if (!widget._isLoading)
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
                    if (!widget._isLoading)
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
      ),
    );
  }
}
