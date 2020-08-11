//import 'dart:async';
//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Pages/HomePage.dart';
import 'package:flutter_chat_app/Widgets/ProgressWidget.dart';
import 'package:flutter_chat_app/Widgets/projectColors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSingIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isSingedIn();
  }

  isSingedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSingIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            currentUserId: preferences.getString('id'),
          ),
        ),
      );
    }
    this.setState(() {
      isLoading = false;
    });
  }

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
              primaryProjectColor,
              accentProjectColor,
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
              onTap: controlSingIn,
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
                      child: isLoading ? circularProgress() : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> controlSingIn() async {
    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSingIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    //SingIn Success
    if (firebaseUser != null) {
      //check if already singup
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;
      //Save Data to Firestore
      if (documentSnapshots.length == 0) {
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'aboutMe': 'i am using Chat App ',
          'createAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
        });
        //Write Data to local
        currentUser = firebaseUser;
        await preferences.setString('id', currentUser.uid);
        await preferences.setString('nickname', currentUser.displayName);
        await preferences.setString('photoUrl', currentUser.photoUrl);
        //await preferences.setString('photoUrl', currentUser.photoUrl);
      } else {
        //Write Data to local
        currentUser = firebaseUser;
        await preferences.setString('id', documentSnapshots[0]['id']);
        await preferences.setString(
            'nickname', documentSnapshots[0]['nickname']);
        await preferences.setString(
            'photoUrl', documentSnapshots[0]['photoUrl']);
        await preferences.setString('aboutMe', documentSnapshots[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: 'Congratulations, Sing in Successful.',backgroundColor: Colors.grey);
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            currentUserId: firebaseUser.uid,
          ),
        ),
      );
    }
    //SingIn Not Success-SingIn Faild
    else {
      Fluttertoast.showToast(msg: 'Try Again, Sing in Failed',backgroundColor: Colors.grey);
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
