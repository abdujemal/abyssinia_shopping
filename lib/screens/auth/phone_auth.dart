
import 'package:abyssinia_shopping/screens/home.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  TextEditingController phoneNumber = TextEditingController();
  GlobalKey prefixKey = GlobalKey();

  String _verificationCode;

  String countryCode = "+251";

  bool isClicked = false;

  TextEditingController pinController = TextEditingController();

  _verifyPhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  Widget prefix() {
    return Container(
        key: prefixKey,
        //padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
        margin: EdgeInsets.only(right: 4.0),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
        child: CountryCodePicker(
          onChanged: (value) {
            countryCode = value.dialCode;
          },
          initialSelection: 'ET',
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      isClicked ? 'Confirm Your OTP' : 'Glad To Meet You',
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

    Widget subTitle = Center(
      child:Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          isClicked
              ? 'Please wait, we are confirming your OTP'
              : 'LogIn or SignIn with your phone number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        )));

    //the button
    Widget sendButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          if (!isClicked) {
            if (phoneNumber.text != 0) {
              print("${countryCode}${phoneNumber.text}");
              _verifyPhone("+" + countryCode + phoneNumber.text);
            setState(() {
              isClicked = true;
            });
            }
          } else {
            setState(() {
              _verificationCode = pinController.text;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text(isClicked ? "Verify" : "Send",
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

    Widget otpForm = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 28.0),
          child: Center(
            child: PinCodeTextField(
              controller: pinController,
              highlightColor: Colors.white,
              highlightAnimation: true,
              highlightAnimationBeginColor: Colors.white,
              highlightAnimationEndColor: Theme.of(context).primaryColor,
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
              wrapAlignment: WrapAlignment.center,
              hasTextBorderColor: Colors.transparent,
              highlightPinBoxColor: Colors.white,
              autofocus: true,
              pinBoxHeight: 60,
              pinBoxWidth: 60,
              pinBoxRadius: 5,
              defaultBorderColor: Colors.transparent,
              pinBoxColor: Color.fromRGBO(255, 255, 255, 0.8),
              maxLength: 5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: sendButton,
        ),
      ],
    );

    Widget phoneForm = Container(
      height: 210,
      child: Stack(
        children: <Widget>[
          Container(
            height: 100,
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
                prefix(),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: phoneNumber,
                      style: TextStyle(fontSize: 16.0),
                      keyboardType: TextInputType.phone,
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.fill)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(253, 184, 70, 0.7),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0),
            child: Column(
              children: [
                isClicked
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(Icons.keyboard_backspace),
                            onPressed: () {
                              setState(() {
                                isClicked = false;
                              });
                            },
                          ),
                        ),
                      )
                    : SizedBox(),
                Spacer(flex: 3),
                title,
                Spacer(),
                subTitle,
                isClicked ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ):
                SizedBox(),
                Spacer(),
                isClicked ? otpForm : phoneForm,
                Spacer(flex: 2),
              ],
            ),
          )
        ],
      ),
    );
  }
}
