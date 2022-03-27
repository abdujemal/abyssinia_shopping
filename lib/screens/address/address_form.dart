import 'dart:async';


import 'package:abyssinia_shopping/app_properties.dart';
import 'package:abyssinia_shopping/models/city.dart';
import 'package:abyssinia_shopping/screens/address/addressList.dart';
import 'package:abyssinia_shopping/screens/address/map_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddAddressForm extends StatefulWidget {
  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  List<String> cities;
  String selectedCity;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = const LatLng(9, 38);
  Set<Marker> markerList = {};
  LatLng _lastLatLng;
  var key = GlobalKey<FormState>();
  Marker selectedMarker;
  List<String> addressInfo;
  bool isSaving = false;
  TextEditingController addressName = TextEditingController(),
      subcity = TextEditingController(),
      wereda = TextEditingController(),
      homeNum = TextEditingController(),
      moreInfo = TextEditingController();
    
    getLocation() async {
      Location _location = new Location();
    Map<String, double> location;
    LocationData lction;
      try {
      lction = await _location.getLocation();
      _lastLatLng = LatLng(lction.latitude,lction.longitude);
      
    }  catch (e) {
      print(e.message);
      location = null;
    }
    }

  @override
  void initState()  {
    

    getLocation();

    // TODO: implement initState
    super.initState();

    DatabaseReference cityRef =
        FirebaseDatabase.instance.reference().child("Available_cities");
    cityRef.once().then((DataSnapshot dataSnapshot) {
      var values = dataSnapshot.value;
      var keys = dataSnapshot.value.keys;
      cities = [];
      for (var key in keys) {
        if (values[key]["availability"] == "enabled") {
          cities.add(values[key]["cityName"]);
          if(mounted){
            setState(() {});
          }
        }
      }
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastLatLng = position.target;
  }

  @override
  Widget build(BuildContext context) {
    Widget finishButton = InkWell(
      onTap: () {
        if (selectedMarker != null && addressInfo != null) {
          setState(() {
            isSaving = true;
          });
          DatabaseReference addressRef =
              FirebaseDatabase.instance.reference().child("Address").push();
          Map<String, Object> map = Map();
          map = {
            "Address_name": addressName.text,
            "address_id": addressRef.key,
            "city": selectedCity,
            "homeNumber": homeNum.text,
            "latitude": selectedMarker.position.latitude.toString(),
            "longitude": selectedMarker.position.longitude.toString(),
            "moreInfo": moreInfo.text,
            "owner": FirebaseAuth.instance.currentUser.uid,
            "subcity": subcity.text,
            "wereda": wereda.text
          };
          addressRef.update(map).whenComplete(() {
            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "You need to write your address info and locate on the map.");
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
          child: Text("Add",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

   
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ExpansionTile(
            leading: Icon(
              Icons.check_circle,
              color: addressInfo == null ? Colors.grey : Colors.green,
            ),
            title: Text("Fill your address Information"),
            children: [
              Form(
                key: key,
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: addressName,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Address Name (my home)'),
                      ),
                    ),
                    cities == null
                        ? CircularProgressIndicator()
                        : Row(
                            children: [
                              Text("City"),
                              Expanded(
                                  child: Center(
                                      child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: DropdownButton(
                                    value: selectedCity,
                                    items: cities
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCity = value;
                                      });
                                    },
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ),
                              ))),
                            ],
                          ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: subcity,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Sub city'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: wereda,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Wereda'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: homeNum,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Home Number(you can say it new)'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: moreInfo,
                        validator: (value) => value.length == 0
                            ? "This Field is required."
                            : null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'More Information (5th block, 3rd floor)'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (key.currentState.validate()) {
                      if (selectedCity != null) {
                        setState(() {
                          addressInfo = [
                            addressName.text,
                            selectedCity,
                            subcity.text,
                            wereda.text,
                            homeNum.text,
                            moreInfo.text
                          ];
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Please select your city");
                      }
                    }
                  },
                ),
              )
            ],
          ),
          ExpansionTile(
            leading: Icon(
              Icons.check_circle,
              color: selectedMarker == null ? Colors.grey : Colors.green,
            ),
            title: Text("Locate Your Location From a Map"),
            children: [
              Container(
                height: 250,
                width: 250,
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 20),
                  mapType: MapType.normal,
                  markers: markerList,
                  onCameraMove: _onCameraMove,
                  onTap: (position) {
                    setState(() {
                      markerList = Set();
                      markerList.add(Marker(
                          markerId: MarkerId("new_marker"),
                          position: position));
                      selectedMarker = Marker(
                          markerId: MarkerId("new_marker"), position: position);
                    });
                  },
                ),
              )
            ],
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isSaving ? CircularProgressIndicator() : finishButton,
          ))
        ],
      ),
    );
  }
}
