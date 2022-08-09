import 'package:firebase_auth/firebase_auth.dart';
import 'package:sk8spotr/models/my_user.dart';
import 'package:sk8spotr/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthService {

  Set<Marker> markers = new Set(); // Empty Set of Markers

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on User
  MyUser? _userFromUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth change user Stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges()
      .map(_userFromUser);
  }
  

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
  
  //register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // create a new doc for user with uid
      markers.add(Marker(
        markerId: MarkerId('marker${markers.length}'),
        position: LatLng(43.549999, -80.250000),
        infoWindow: InfoWindow(
          title: 'Skate Spot',
          snippet: 'marker${markers.length}'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
      await DatabaseService(uid: user!.uid).updateUserData(markers); //add empty set of markers to user record
      return _userFromUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}