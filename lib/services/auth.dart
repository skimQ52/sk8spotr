import 'package:firebase_auth/firebase_auth.dart';
import 'package:sk8spotr/models/my_user.dart';

class AuthService {

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