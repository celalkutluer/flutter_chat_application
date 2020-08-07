import 'package:flutter/material.dart';
import 'Pages/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chat App', style: TextStyle(fontSize: 26.0, color: Colors.white, fontWeight: FontWeight.bold),),
        ),
        body: Center(
          child: Text('Mesajlaşma uygulamasına hoşgeldiniz!!!', style: TextStyle(fontSize: 20.0, color: Colors.blueAccent),),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
