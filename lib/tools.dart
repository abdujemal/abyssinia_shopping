import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void goTo({@required context, @required to}) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => to));
}

Future<bool> checkProduct(id) {
  FirebaseDatabase.instance
      .reference()
      .child("Products")
      .child(id)
      .once()
      .then((DataSnapshot snapshot) {
    var values = snapshot.value;
    var keys = snapshot.value.keys;
    for (var key in keys) {
      if (values[key]["Product_id"] == id) {
        return true;
      }
    }
  });
}
