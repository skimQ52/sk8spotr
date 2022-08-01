import 'package:flutter/material.dart';
import 'package:sk8spotr/models/my_user.dart';
import 'package:sk8spotr/screens/authenticate/authenticate.dart';
import 'package:sk8spotr/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    // return home or authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}