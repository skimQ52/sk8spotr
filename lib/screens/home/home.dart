import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sk8spotr/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isDrawerOpen = false;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(43.549999, -80.250000),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;

  Set<Marker> markers = new Set();

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
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: markers,
        onLongPress: _createMarker,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

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
