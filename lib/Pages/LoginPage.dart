import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Pages/HomePage.dart';
import 'package:flutter_chat_app/Widgets/ProgressWidget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(),*/
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(236, 0, 140, 1),
              Color.fromRGBO(252, 103, 103, 1),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chat App',
              style: TextStyle(
                  fontSize: 82.0,
                  color: Colors.white70,
                  fontFamily: 'Signatra'),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/google_signin_button_white.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: circularProgress(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
