import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 100,
          padding: const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 10),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Center(
            child: Text(
              "We have sent you an email verfication. Go to your email account and verify.",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      offset: Offset(0, 5),
                      blurRadius: 10.0,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
