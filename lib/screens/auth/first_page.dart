import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/wedgets/google_sign_in_btn.dart';
import 'package:flutter/material.dart';

import 'register_page.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'Welcome to Abyssinia shopping',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login or SignIn to your account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget loginForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Continue with:"),
                ),
                SignupButtonWidget("google"),
                SignupButtonWidget("email"),
                SignupButtonWidget("phone"),
              ],
            ),
          ),
        ],
      ),
    );

    // Widget forgotPassword = Padding(
    //   padding: const EdgeInsets.only(bottom: 20),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(
    //         'Forgot your password? ',
    //         style: TextStyle(
    //           fontStyle: FontStyle.italic,
    //           color: Color.fromRGBO(255, 255, 255, 0.5),
    //           fontSize: 14.0,
    //         ),
    //       ),
    //       InkWell(
    //         onTap: () {},
    //         child: Text(
    //           'Reset password',
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold,
    //             fontSize: 14.0,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.fill)),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    width: 100,
                    height: 100,
                  ),
                ),
                welcomeBack,
                SizedBox(
                  height: 50,
                ),
                subTitle,
                SizedBox(
                  height: 50,
                ),
                loginForm,
              ],
            ),
          )
        ],
      ),
    );
  }
}
