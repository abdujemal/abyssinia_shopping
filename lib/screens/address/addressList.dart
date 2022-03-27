import 'package:abyssinia_shopping/custom_background.dart';
import 'package:abyssinia_shopping/models/address.dart';
import 'package:abyssinia_shopping/models/city.dart';
import 'package:abyssinia_shopping/screens/address/add_address_page.dart';
import 'package:abyssinia_shopping/screens/faq_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../notifications_page.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  List<Address> myAddresses;

  DatabaseReference addressRef =
      FirebaseDatabase.instance.reference().child("Address");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  void refresh() {
    addressRef.once().then((DataSnapshot dataSnapShot) {
      myAddresses = [];
      var values = dataSnapShot.value;
      var keys = dataSnapShot.value.keys;
      for (var key in keys) {
        if (values[key]["owner"] == FirebaseAuth.instance.currentUser.uid) {
          Address address = Address(
              values[key]["Address_name"],
              values[key]["address_id"],
              values[key]["city"],
              values[key]["homeNumber"],
              values[key]["latitude"],
              values[key]["longitude"],
              values[key]["moreInfo"],
              values[key]["owner"],
              values[key]["subcity"],
              values[key]["wereda"]);

          myAddresses.add(address);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.keyboard_backspace_outlined)),
          Expanded(
              child: Center(
                  child: Text(
            "My Addresses",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ))),
          IconButton(
              onPressed: () {
                setState(() {
                  myAddresses = null;
                  refresh();
                });
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
    );

    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        body: myAddresses == null
            ? Center(child: CircularProgressIndicator())
            : myAddresses.length == 0
                ? Center(
                    child: GestureDetector(
                      child: Text("You do not have an address. Learn more"),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FaqPage()));
                      },
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      appBar,
                      Flexible(
                        child: ListView.builder(
                          itemCount: myAddresses.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(myAddresses[index].Address_name),
                              subtitle: Text(myAddresses[index].latitude +
                                  ", " +
                                  myAddresses[index].longitude),
                              leading: Icon(Icons.location_on_outlined),
                              trailing: myAddresses == null
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          addressRef
                                              .child(
                                                  myAddresses[index].address_id)
                                              .remove();
                                          refresh();
                                          myAddresses = null;
                                        });
                                      },
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddAddressPage()));
          },
          child: Icon(Icons.add),
          tooltip: "Add Address",
        ),
      ),
    );
  }
}
