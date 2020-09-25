import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartOne extends StatelessWidget {
  static const String rooteName = '/start1';
  final BuildContext context;

  const StartOne({Key key, this.context}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          imageToShow(),
          textTitle(),
          text(),
        ],
      ),
    );
  }

  Widget text() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 10,
          left: 20,
          right: 20,
        ),
        child: Text(
          "Scan your card to make the presence",
          textAlign: TextAlign.center,
          style: GoogleFonts.dMSans(
            textStyle: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }

  Widget textTitle() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          "Presence and visit",
          textAlign: TextAlign.center,
          style: GoogleFonts.dMSans(
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget imageToShow() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/scanern.jpg'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
