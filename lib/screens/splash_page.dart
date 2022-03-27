import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/screens/auth/register_page.dart';
import 'package:abyssinia_shopping/screens/auth/first_page.dart';
import 'package:abyssinia_shopping/screens/home.dart';
import 'package:abyssinia_shopping/screens/intro_page.dart';
import 'package:abyssinia_shopping/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> opacity;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigationPage() {
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser == null) {
      goTo(context: context, to: IntroPage());
    } else {
      if (firebaseAuth.currentUser.email != null &&
          firebaseAuth.currentUser.emailVerified) {
        goTo(context: context, to: Home());
      } else {
        goTo(context: context, to: Home());
      }
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.jpg'), fit: BoxFit.fill)),
      child: Container(
        decoration: BoxDecoration(color: transparentYellow),
        child: SafeArea(
          child: new Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Opacity(
                        opacity: opacity.value,
                        child: new Image.asset(
                          'assets/logo.png',
                          width: 200,
                          height: 200,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Powered by '),
                          TextSpan(
                              text: 'Abyssinia Tech',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
