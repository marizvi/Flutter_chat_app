import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/screens/user_chatscreen.dart';
import 'package:chat_app/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print(
      "Handling a background message: ${message.notification!.title}\n ${message.notification!.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//2
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  ); //necessary to receive notifications when app is running in background

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.pink,
            accentColorBrightness: Brightness
                .dark, // any contrasting colour on this pink should be a bright colour
            buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.deepPurple,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            // this stream will emit a new value whenever the auth state changes
            //authstatechange means whenever user signup,login,logout, and also
            //will check while loading whether cached token is present or not
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting)
                return SplashScreen();
              if (userSnapshot.hasData) //means we found the token
              {
                return Chatscreen();
              }
              return AuthScreeen();
            }),
        routes: {
          '/user_screen': (ctx) => UsersScreen(),
          '/user_chatscreen': (ctx) => UserChatscreen(),
        });
  }
}
