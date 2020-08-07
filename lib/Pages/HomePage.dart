import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_app/Pages/ChattingPage.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/Pages/AccountSettingsPage.dart';
import 'package:flutter_chat_app/Widgets/ProgressWidget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        onPressed: logoutUser,
        icon: Icon(Icons.close),
        label: Text('Sing Out'));
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }

}


class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}
