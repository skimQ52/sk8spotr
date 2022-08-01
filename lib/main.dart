import 'package:flutter/material.dart';
import 'package:sk8spotr/models/my_user.dart';
import 'package:sk8spotr/screens/wrapper.dart';
import 'package:sk8spotr/services/auth.dart';
import 'screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<MyUser?>.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
      title: 'sk8spotr',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    ),
  ));
}