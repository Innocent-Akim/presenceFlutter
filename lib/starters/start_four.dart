import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/app/source/constants.dart';

class StartFour extends StatelessWidget {
  final BuildContext context;

  const StartFour({Key key, this.context}) : super(key: key);
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
          "The Congolese micro-credits company, SMICO SA in acronym",
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
          "Welcom to smico",
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
      width: MediaQuery.of(context).size.width,
      height: 200,
      alignment: Alignment.center,
      child: Image.asset(
        "${pathImage}",
        width: MediaQuery.of(context).size.width * 0.4,
      ),
    );
  }
}
// decoration: BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage('assets/logo smico.png'),
//         fit: BoxFit.contain,
//       ),
//     ),
