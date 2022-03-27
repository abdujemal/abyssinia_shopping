import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/models/city.dart';
import 'package:abyssinia_shopping/models/user.dart';
import 'package:abyssinia_shopping/screens/address/add_address_page.dart';
import 'package:abyssinia_shopping/screens/address/addressList.dart';
import 'package:abyssinia_shopping/screens/address/address_form.dart';
import 'package:abyssinia_shopping/screens/faq_page.dart';
import 'package:abyssinia_shopping/screens/main/main_page.dart';

import 'package:abyssinia_shopping/screens/profile/profile.dart';
import 'package:abyssinia_shopping/screens/settings/settings_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'order/order_list.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Users user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child("Users");
    userRef.once().then((DataSnapshot dataSnapshot) {
      var values = dataSnapshot.value;
      var keys = dataSnapshot.value.keys;
      for (var key in keys) {
        if (key == FirebaseAuth.instance.currentUser.uid) {
          user = Users(
              values[key]["Invited_by"],
              values[key]["User_id"],
              values[key]["User_name"],
              values[key]["User_nick_name"],
              values[key]["address1"],
              values[key]["address2"],
              values[key]["cutphone"],
              values[key]["email"],
              values[key]["image"],
              values[key]["phone"],
              values[key]["total_invitation"]);
          setState(() {
            print(user.User_name);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile(false,user)));
                  },
                  child: CircleAvatar(
                    maxRadius: 48,
                    backgroundImage:
                        NetworkImage(user == null ? "" : user.image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    user == null ? "User name" : user.User_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text('Shipping Address'),
                  leading: Icon(
                    Icons.location_pin,
                    size: 40,
                  ),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AddressList())),
                ),
                Divider(),
                ListTile(
                  title: Text('My Orders'),
                  subtitle: Text('Orders that you ordered '),
                  leading: Icon(
                    FontAwesomeIcons.truck,
                    size: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => OrderList())),
                ),
                Divider(),
                ListTile(
                  title: Text('Settings'),
                  subtitle: Text('Privacy and logout'),
                  leading: Image.asset(
                    'assets/icons/settings_icon.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SettingsPage())),
                ),
                Divider(),
                ListTile(
                  title: Text('Help & Support'),
                  subtitle: Text('Help center and legal support'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('FAQ'),
                  subtitle: Text('Questions and Answer'),
                  leading: Image.asset('assets/icons/faq.png'),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => FaqPage())),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
