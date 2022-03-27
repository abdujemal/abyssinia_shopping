import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/screens/auth/verify_email.dart';
import 'package:abyssinia_shopping/screens/home.dart';
import 'package:abyssinia_shopping/services/auth.dart';
import 'package:abyssinia_shopping/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'forgot_password_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hasAccount = true;

  bool notverified = false;

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController cmfPassword = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Glad To Meet You',
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
          hasAccount
              ? 'Login by your email.'
              : 'Create your new account for future uses.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget registerButton = InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            isRegistering = true;
          });
          if (hasAccount) {
            await Authentication()
                .SignInWithEmailAndPassword(
                    email: email.text, password: password.text, state: "login")
                .then((value) {
              if (value.user != null) {
                if (value.user.emailVerified) {
                  goTo(context: context, to: Home());
                } else {
                  setState(() {
                    notverified = true;
                  });
                }
              }
            });
          } else {
            await Authentication()
                .SignInWithEmailAndPassword(
                    email: email.text, password: password.text, state: "signin")
                .then((value) {
              if (value.user != null) {
                if (value.user.emailVerified) {
                  User user = FirebaseAuth.instance.currentUser;
                  Map<String, Object> map = Map();
                  map = {
                    "Invited_by": "none",
                    "User_id": user.uid,
                    "User_name": user.displayName == null ? "" : user.displayName,
                    "User_nick_name": "",
                    "address1": "",
                    "address2": "",
                    "cutphone": "",
                    "email": user.email == null ? "" : user.email,
                    "image": user.photoURL == null ? "" : user.photoURL,
                    "phone": user.phoneNumber == null ? "" : user.phoneNumber,
                    "total_invitation": "0"
                  };
                  FirebaseDatabase.instance.reference().child("Users").child(user.uid).update(map);
                  goTo(context: context, to: Home());
                } else {
                  setState(() {
                    notverified = true;
                  });
                }
              }
            });
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 60,
        child: Center(
            child: new Text(hasAccount ? "Log In" : "Register",
                style: const TextStyle(
                    color: const Color(0xfffefefe),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0))),
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
      ),
    );

    Widget registerForm = Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (String v) {
                        if (v.length == 0) {
                          return 'Please write your email!';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(v)) {
                          return 'Please write the correct email!';
                        }
                      },
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintText: "Example@website.com",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (String v) {
                        if (v.length == 0) {
                          return 'Please write your password!';
                        }
                        if (hasAccount) {
                          cmfPassword.text = v;
                        }
                      },
                      controller: password,
                      style: TextStyle(fontSize: 16.0),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: hasAccount ? "Your password" : "New Password",
                      ),
                    ),
                  ),
                  hasAccount
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            validator: (String v) {
                              if (v.length == 0) {
                                return 'Please confirm your password!';
                              }
                              if (v != password.text) {
                                return 'Please write the correct password!';
                              }
                            },
                            controller: cmfPassword,
                            style: TextStyle(fontSize: 16.0),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Confirm your Password",
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  isRegistering
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : registerButton,
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Text(
                      hasAccount
                          ? "You don't have an account? | Sign up"
                          : "You have an account? | Log In",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      setState(() {
                        if (hasAccount) {
                          hasAccount = false;
                        } else {
                          hasAccount = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  hasAccount
                      ? GestureDetector(
                          child: Text(
                              "Did you forget your password? | Forgot Password",
                              style: TextStyle(color: Colors.blue)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgotPasswordPage()));
                          },
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Widget socialRegister = Column(
    //   children: <Widget>[
    //     Text(
    //       'You can sign in with',
    //       style: TextStyle(
    //           fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.find_replace),
    //           onPressed: () {},
    //           color: Colors.white,
    //         ),
    //         IconButton(
    //             icon: Icon(Icons.find_replace),
    //             onPressed: () {},
    //             color: Colors.white),
    //       ],
    //     )
    //   ],
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
            child: notverified
                ? VerifyEmail()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 3),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(),
                      registerForm,
                      Spacer(flex: 2),
                      // Padding(
                      //     padding: EdgeInsets.only(bottom: 20), child: socialRegister)
                    ],
                  ),
          ),
          Positioned(
            top: 35,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
