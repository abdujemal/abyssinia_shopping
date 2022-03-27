import 'package:abyssinia_shopping/app_properties.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';



class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();

  GlobalKey prefixKey = GlobalKey();
  double prefixWidth = 0;
  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Forgot your Password?',
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
          'Enter your email and submit to reset your password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget sendButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          if (_key.currentState.validate()) {
            FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Verify Email",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget EmailForm = Container(
      height: 250,
      child: Stack(
        children: <Widget>[
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 30),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (v) {
                              if (v.length == 0) {
                                return "Please write your email";
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(v)) {
                                return "Please write the correct email";
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Example@website.com"),
                            controller: email,
                            style: TextStyle(fontSize: 16.0),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          sendButton,
        ],
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.fill)),
        child: Container(
          decoration: BoxDecoration(color: transparentYellow),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 3),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(flex: 2),
                      EmailForm,
                      Spacer(flex: 2),
                    ],
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
