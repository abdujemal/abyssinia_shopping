import 'package:abyssinia_shopping/screens/main/main_page.dart';
import 'package:abyssinia_shopping/screens/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 bool hasAccount = false;

  @override
  Widget build(BuildContext context) {
    
    return  MainPage();
  }
}