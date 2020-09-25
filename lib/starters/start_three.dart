import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartThree extends StatelessWidget {
  final BuildContext context;

  const StartThree({Key key, this.context}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
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
          "identify a person if possible",
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
          "Person identification",
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
          image: AssetImage('assets/span.jpg'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
