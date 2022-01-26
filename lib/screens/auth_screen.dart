import 'package:chat_app/widget/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreeen extends StatefulWidget {
  @override
  _AuthScreeenState createState() => _AuthScreeenState();
}

class _AuthScreeenState extends State<AuthScreeen> {
  //earlier firebase authentication was through rest api
  //here we are actually going to use firebase authentication sdk

  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String? email,
    String? password,
    String? username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
        //we are going to make it false only in error blocks
        //because if while loading there is no error then we are going to
        // jump to other page
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email as String, password: password as String);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email as String, password: password as String);
        await FirebaseFirestore.instance
            .collection(
                'users') //if users collection is not present then it will be created
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (err) {
      // errors returned by password regarding invalid email or password
      print(err.message);
      var message = 'An error Occured please check your credentials!';
      if (err.message != null) {
        message = err.message as String;
      }
      //since for snackbar we need context so we took it through constructor
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
