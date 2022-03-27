import 'package:abyssinia_shopping/models/user.dart';
import 'package:abyssinia_shopping/screens/main/main_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../app_properties.dart';

class Profile extends StatefulWidget {
  bool isFirst;
  Users user;
  Profile(this.isFirst, this.user);
  @override
  _ProfileState createState() => _ProfileState(isFirst, user);
}

class _ProfileState extends State<Profile> {
  bool isFirst;
  Users user;

  bool isSaving = false;
  _ProfileState(this.isFirst, this.user);
  String selectedImage;
  List<String> images;
  var currentuser = FirebaseAuth.instance.currentUser;
  var key = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController(),
      userPhoneController = TextEditingController(),
      userEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (isFirst) {
     
      currentuser.displayName != null
          ? userNameController =
              TextEditingController(text: currentuser.displayName)
          : userNameController = TextEditingController();

      currentuser.phoneNumber != null
          ? userPhoneController =
              TextEditingController(text: currentuser.phoneNumber)
          : userPhoneController = TextEditingController();

      currentuser.email != null
          ? userEmailController = TextEditingController(text: currentuser.email)
          : userEmailController = TextEditingController();
      currentuser.photoURL != null
          ? selectedImage = currentuser.photoURL
          : selectedImage = null;
      setState(() {});
    } else {
      userNameController = TextEditingController(text: user.User_name);
      userPhoneController = TextEditingController(text: user.phone);
      userEmailController = TextEditingController(text: user.email);
      selectedImage = user.image;
      setState(() {});
    }

    DatabaseReference imageeRef =
        FirebaseDatabase.instance.reference().child("Images");
    imageeRef.once().then((DataSnapshot snapshot) {
      images = [];
      var values = snapshot.value;
      var keys = snapshot.value.keys;
      for (var key in keys) {
        images.add(values[key]["image"]);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget finishButton = InkWell(
      onTap: () {
        if (key.currentState.validate()) {
          if (selectedImage != null) {
            setState(() {
              isSaving = true;
            });
            String uid = currentuser.uid;
            DatabaseReference userRef =
                FirebaseDatabase.instance.reference().child("Users");
            Map<String, Object> map = Map();
            map = {
              "Invited_by": "none",
              "User_id": uid,
              "User_name": userNameController.text,
              "User_nick_name":
                  userNameController.text + userPhoneController.text,
              "address1": "",
              "address2": "",
              "cutphone": "",
              "email": userEmailController.text,
              "image": selectedImage,
              "phone": userPhoneController.text,
              "total_invitation": "0",
            };
            userRef.child(uid).update(map).whenComplete(() {
              Fluttertoast.showToast(msg: "Your profile is updated.");
              if (isFirst) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainPage()));
              } else {
                Navigator.pop(context);
              }
            });
          } else {
            Fluttertoast.showToast(msg: "You have to choose your avatar");
          }
        }
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 1.5,
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
        child: Center(
          child: Text("Save",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              height: 45,
            ),
            selectedImage == null
                ? Icon(
                    Icons.account_circle,
                    size: 140,
                  )
                : Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(selectedImage),
                            fit: BoxFit.contain)),
                  ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "User profile",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 35, left: 35),
              child: Text(
                "Choose your avatar",
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            images == null
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircularProgressIndicator(),
                  ))
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage = images[index];
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.orange),
                                    image: DecorationImage(
                                        image: NetworkImage(images[index]),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(color: Colors.orange)),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: userNameController,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Full Name'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(color: Colors.orange)),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: userPhoneController,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Phone number'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(color: Colors.orange)),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: userEmailController,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: isSaving ? CircularProgressIndicator() : finishButton,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
