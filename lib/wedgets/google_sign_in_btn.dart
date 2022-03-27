import 'package:abyssinia_shopping/screens/auth/phone_auth.dart';
import 'package:abyssinia_shopping/screens/auth/register_page.dart';
import 'package:abyssinia_shopping/screens/home.dart';
import 'package:abyssinia_shopping/services/auth.dart';
import 'package:abyssinia_shopping/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupButtonWidget extends StatelessWidget {
  String type;
  var icon, text;
  
  Authentication authentication = Authentication();

  SignupButtonWidget(this.type);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (type == "google") {
      icon = FontAwesomeIcons.google;
      text = "Sign In With Google";
    } else if (type == "email") {
      icon = Icons.email;
      text = "Sign In With Email";
    } else if (type == "phone") {
      icon = CupertinoIcons.phone;
      text = "Sign In With Phone Number";
    }

    return Container(
        padding: EdgeInsets.all(4),
        child: OutlineButton.icon(
            label: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            highlightColor: Colors.black,
            textColor: Colors.black,
            icon: FaIcon(
              icon,
              color: type == "google" ? Colors.red : Colors.blue,
            ),
            onPressed: () {
              
              if (type == "google") {
                authentication.signInWithGoogle().then((value) async {
                  if (value.user != null) {
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
                  }
                });
              } else if (type == "email") {
                navigate(context, RegisterPage());
              } else if (type == "phone") {
                navigate(context, PhoneAuthPage());
              }
            }));
  }

  void navigate(context, to) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => to));
  }
}
