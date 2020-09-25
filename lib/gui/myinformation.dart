import 'package:flutter/material.dart';
import 'package:presence/outils/Apptheme.dart';

class MyInformation extends StatefulWidget {
  static const String rootName = '/myinformation';
  @override
  _MyInformation createState() {
    return _MyInformation();
  }
}

class _MyInformation extends State<MyInformation> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: HotelAppTheme.buildLightTheme(),
        child: Container(
          child: SafeArea(
              child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [customCard()],
            ),
          )),
        ));
  }

  Widget customCard() {
    return Expanded(
      child: Center(
        child: Container(
          child: Text("WELCOM TO SMICO soft"),
        ),
      ),
    );
  }
}
