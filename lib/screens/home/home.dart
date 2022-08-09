import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sk8spotr/services/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isDrawerOpen = false;

  static const _initialCameraPosition = CameraPosition(
    target:  LatLng(43.549999, -80.250000),
    zoom: 15,
  );

  late GoogleMapController _googleMapController; // Google Maps Controller
  Set<Marker> markers = new Set(); // Set of Markers

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('sk8spotr'),
        leading: IconButton(
          icon: isDrawerOpen ? const Icon(Icons.arrow_back) : const Icon(Icons.menu),
          onPressed: () {
            if (!isDrawerOpen) { // open the drawer
              // this._key.currentState.openDrawer();
              print("yo");
            } else { // close the drawer
              //Navigator.pop(context);
              print("bye");
            }
            setState(() {
              isDrawerOpen = !isDrawerOpen;
            });
          },
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign Out"),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        //onMapCreated: _onMapCreated,
        markers: markers,
        onLongPress: _createMarker,
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        //onPressed: () => _createMarker(_initialCameraPosition.target), //create marker where crosshair is (center of screen)
        onPressed: () async {
          Position position = await _determinePosition();
          _createMarker(LatLng(position.latitude, position.longitude));
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  //void _openCreateWindow

  void _createMarker(LatLng pos) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('marker${markers.length}'),
        position: pos,
        infoWindow: InfoWindow(
          title: 'Skate Spot',
          snippet: 'marker${markers.length}'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
    
  }
}
