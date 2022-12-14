import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.white,
          size: 50.0,
        )
      )
    );
  }
}