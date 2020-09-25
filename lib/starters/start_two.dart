import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartTwo extends StatelessWidget {
  static const String rooteName = '/start2';
  final BuildContext context;

  const StartTwo({Key key, this.context}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      child: Column(
        children: <Widget>[
          imageToShow(context),
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
          "To make the movement, you must scan your service card and enter the reason for your trip",
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
          "Movement",
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

  Widget imageToShow(context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/smart_login.jpg'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
