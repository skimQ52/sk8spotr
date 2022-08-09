import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference spotCollection = FirebaseFirestore.instance.collection('spots');

  Future updateUserData(Set<Marker> markers) async {
    return await spotCollection.doc(uid).set({
      'markers': markers,
    });
  }
}