import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyprus bus stations',
      home: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();
  // For storing the current position
  late Position _currentPosition;
  // For controlling the view of the Map
  late GoogleMapController mapController;

  static const CameraPosition _initialLocation = CameraPosition(
    target: LatLng(34.7028694, 33.0342098),
    zoom: 13,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      // await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialLocation,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _getCurrentLocation,
          label: const Text('My location'),
          icon: const Icon(Icons.location_pin),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
