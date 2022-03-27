import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocator extends StatefulWidget {
  @override
  _MapLocatorState createState() => _MapLocatorState();
}

class _MapLocatorState extends State<MapLocator> {
  GoogleMapController _controller;
  List<Marker> markerList = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map"),),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        markers: Set.from(markerList),
        initialCameraPosition: CameraPosition(target: LatLng(9, 37)),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: (argument) {
          _controller.animateCamera(CameraUpdate.newLatLng(argument));

          markerList
              .add(Marker(position: argument, markerId: MarkerId("new_marker")));
          setState(() {});
        },
      ),
    );
  }
}
